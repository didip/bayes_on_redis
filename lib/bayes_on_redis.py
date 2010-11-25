import operator, math
from redis import Redis

class BayesOnRedis:
    categories_key = "BayesOnRedis:categories"

    def __init__(self, **kwargs):
        self.redis = Redis(host=kwargs['redis_host'], port=int(kwargs['redis_port']), db=int(kwargs['redis_db']))

    def flushdb(self):
        self.redis.flushdb()


    def train(self, category, text):
        category = category.lower()
        self.redis.sadd(self.__class__.categories_key, category)

        for word, count in self.count_occurance(text).iteritems():
            self.redis.hincrby(self.redis_category_key(category), word, count)

    def learn(self, category, text):
        self.train(category, text)


    def untrain(self, category, text):
        category = category.lower()

        for word, count in self.count_occurance(text).iteritems():
            word_count_atm = self.redis.hget(self.redis_category_key(category), word)
            new_count = (word_count_atm - count) if (word_count_atm >= count) else 0

            self.redis.hset(self.redis_category_key(category), word, new_count)


    def unlearn(self, category, text):
        self.untrain(category, text)


    def classify(self, text):
        scores = {}

        for category in self.redis.smembers(self.__class__.categories_key):
            words_count_per_category = reduce(lambda x, y: x + y, map(float, self.redis.hvals(self.redis_category_key(category))))

            if words_count_per_category <= 0:
                self.redis.srem(self.__class__.categories_key, category)

            scores[category] = 0

            for word, count in self.count_occurance(text).iteritems():
                tmp_score = self.redis.hget(self.redis_category_key(category), word)
                if tmp_score and float(tmp_score) > 0.0:
                    tmp_score = float(tmp_score)
                else:
                    tmp_score = 0.1

                scores[category] += math.log(tmp_score / words_count_per_category)

        return scores


    def classify_for_human(self, text):
        return sorted(self.classify(text).iteritems(), key=operator.itemgetter(1))[-1][0]


    def redis_category_key(self, category):
        return "BayesOnRedis:cat:%s" % category


    # Incoming text is always downcased
    def count_occurance(self, text=''):
        if not isinstance(text, basestring):
            raise Exception("input must be instance of String")

        frequencies = {}
        for word in text.lower().split():
            frequencies[word] = (frequencies[word] if frequencies.has_key(word) else 0) + 1

        return frequencies
