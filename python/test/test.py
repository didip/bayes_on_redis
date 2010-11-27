#!/usr/bin/python
import sys, os.path
sys.path.append(os.path.abspath(os.path.join(__file__, '..', '..', 'bayes_on_redis')))

from bayes_on_redis import BayesOnRedis

bor = BayesOnRedis(redis_host='127.0.0.1', redis_port=6379, redis_db=5)
bor.flushdb()


# Classification tests

bor.learn( "good", "sweet awesome kick-ass cool pretty smart" )
bor.learn( "bad", "sucks lame boo death bankrupt loser sad" )

text = "even though you are sweet and awesome ninja, you still sucks."
expected = 'good'
print "Expected: %s --- Result: %s" % (expected, bor.classify(text))

text = "super lame pirate"
expected = 'bad'
print "Expected: %s --- Result: %s" % (expected, bor.classify(text))

# -----------------------

bor.train("programming", "opera awesome web browser javascript lua c++ python www internet firefox")
text = "Opera (the web browser) 11 beta, featuring extensions and tab stacking - now available for download."
expected = 'programming'
print "Expected: %s --- Result: %s" % (expected, bor.classify(text))

# -----------------------

bor.train("programming", "ruby git programming language")
text = "Erik Andrejko shows us some of the common workflows and best features of git, making Ruby and git a powerful combination."
expected = 'programming'
print "Expected: %s --- Result: %s" % (expected, bor.classify(text))

# -----------------------

bor.train("programming", "python is the best programming language")
text = "Always having fun with ruby and python"
expected = 'programming'
print "Expected: %s --- Result: %s" % (expected, bor.classify(text))

# -----------------------
# Stopwords tests
print "Expected: Stopwords length should be > 0 --- Result: %s" % len(bor.stopwords.to_list())

# -----------------------
# occurance tests
print bor.count_occurance("one or two cows did not scare me. It is chicken that does.")
