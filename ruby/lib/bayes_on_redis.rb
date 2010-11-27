require "rubygems"
require "redis"

class BayesOnRedis
  CATEGORIES_KEY = "BayesOnRedis:categories"
  ONE_OR_TWO_WORDS_RE = /\b\w{1,2}\b/mi
  NON_ALPHANUMERIC_AND_NON_DOT_RE = /[^\w\.]/mi

  attr_reader :redis, :stopwords

  def initialize(options)
    @redis = Redis.new(:host => options[:redis_host], :port => options[:redis_port], :db => options[:redis_db])
    @stopwords = Stopword.new
  end

  def flushdb
    @redis.flushdb
  end

  # training for a category
  def train(category, text)
    category = category.downcase
    @redis.sadd(CATEGORIES_KEY, category)

    count_occurance(text).each do |word, count|
      @redis.hincrby(redis_category_key(category), word, count)
    end
  end
  alias_method :learn, :train

  def untrain(category, text)
    category = category.downcase

    count_occurance(text).each do |word, count|
      word_count_atm = @redis.hget(redis_category_key(category), word)
      if (word_count_atm >= count)
        new_count = (word_count_atm - count)
      else
        new_count = 0
      end
      @redis.hset(redis_category_key(category), word, new_count)
    end
  end
  alias_method :unlearn, :untrain

  def score(text)
    scores = {}

    @redis.smembers(CATEGORIES_KEY).each do |category|
      words_count_per_category = @redis.hvals(redis_category_key(category)).inject(0) {|sum, score| sum + score.to_i}
      @redis.srem(CATEGORIES_KEY, category) if words_count_per_category <= 0

      scores[category] = 0

      count_occurance(text).each do |word, count|
        tmp_score = @redis.hget(redis_category_key(category), word).to_i
        tmp_score = 0.1 if tmp_score <= 0

        scores[category] += Math.log(tmp_score / words_count_per_category.to_f)
      end
    end

    return scores
  end

  def classify(text)
    (score(text).sort_by { |score| -score[1] })[0][0]    # [0][0] -> first score, get the key
  end

  private
  def redis_category_key(category)
    "BayesOnRedis:cat:#{category}"
  end

  # Incoming text is always downcased
  def count_occurance(text='')
    raise "input must be instance of String" unless text.is_a?(String)

    text_chunks = text.downcase.gsub(ONE_OR_TWO_WORDS_RE, '').gsub(NON_ALPHANUMERIC_AND_NON_DOT_RE, ' ').gsub(@stopwords.to_re, '').gsub(/\./, '').split
    text_chunks.inject(Hash.new(0)) do |container, word|
      container[word] += 1; container
    end
  end

  def remove_stopwords
    @redis.smembers(CATEGORIES_KEY).each do |category|
      @stopwords.to_a.each do |stopword|
        @redis.hdel(redis_category_key(category), stopword)
      end
    end
  end
end


class Stopword
  def initialize
    @stopwords = File.read(File.expand_path(File.join(__FILE__, "..", "..", "datasets", "stopwords.txt"))).split
  end

  def to_a
    @stopwords
  end

  def to_re
    @to_re ||= /\b(#{@stopwords.join('|')})\b/mi
  end
end