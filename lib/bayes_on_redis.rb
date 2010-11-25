require "rubygems"
require "redis"

class BayesOnRedis
  CATEGORIES_KEY = "BayesOnRedis:categories"

  def initialize(options)
    @redis = Redis.new(:host => options[:redis_host], :port => options[:redis_port], :db => options[:redis_db])
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

  def classify(text)
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

  def classify_for_human(text)
    (classify(text).sort_by { |score| -score[1] })[0][0]    # [0][0] -> first score, get the key
  end

  private
  def redis_category_key(category)
    "BayesOnRedis:cat:#{category}"
  end

  # Incoming text is always downcased
  def count_occurance(text)
    text.downcase.split.inject(Hash.new(0)) do |container, word|
      container[word] += 1; container
    end
  end
end