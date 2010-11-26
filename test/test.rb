#!/usr/bin/ruby
require 'lib/bayes_on_redis'

bor = BayesOnRedis.new(:redis_host => '127.0.0.1', :redis_port => 6379, :redis_db => 5)
bor.flushdb


# Classification tests

bor.learn "good", "sweet awesome kick-ass cool pretty smart"
bor.learn "bad", "sucks lame boo death bankrupt loser sad"

text = "even though you are sweet and awesome ninja, you still sucks."
expected = 'good'
puts bor.classify(text)
puts "Expected: #{expected} --- Result: #{bor.classify_for_human(text)}"

text = "super lame pirate"
expected = 'bad'
puts bor.classify(text)
puts "Expected: #{expected} --- Result: #{bor.classify_for_human(text)}"

# -----------------------

bor.train "programming", "opera awesome web browser javascript lua c++ python www internet firefox"
text = "Opera (the web browser) 11 beta, featuring extensions and tab stacking - now available for download."
expected = 'programming'
puts bor.classify(text)
puts "Expected: #{expected} --- Result: #{bor.classify_for_human(text)}"

# -----------------------

bor.train "programming", "ruby git programming language"
text = "Erik Andrejko shows us some of the common workflows and best features of git, making Ruby and git a powerful combination."
expected = 'programming'
puts bor.classify(text)
puts "Expected: #{expected} --- Result: #{bor.classify_for_human(text)}"

# -----------------------

bor.train "programming", "python is the best programming language"
text = "Always having fun with ruby and python"
expected = 'programming'
puts bor.classify(text)
puts "Expected: #{expected} --- Result: #{bor.classify_for_human(text)}"

# -----------------------
# Stopwords tests
puts "Expected: Stopwords length should be > 0 --- Result: #{bor.stopwords.to_a.size}"
