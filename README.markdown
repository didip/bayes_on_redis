# What is BayesOnRedis?

Bayesian classifier on top of Redis

## Why on Redis?

Because of its persistent but also in-memory data structures, Redis is perfect for weeks of machine learning.

## How to install?

    gem install bayes_on_redis

## Getting started

    # Create instance of BayesOnRedis and pass your Redis information.
    bor = BayesOnRedis.new(:redis_host => '127.0.0.1', :redis_port => 6379, :redis_db => 5)

    # Teach it
    bor.train "good", "sweet awesome kick-ass cool pretty smart"
    bor.train "bad", "sucks lame boo death bankrupt loser sad"

    # Then ask it to classify text.
    bor.classify("awesome kick-ass ninja can still be lame.")

## Contributing

[Fork http://github.com/didip/bayes_on_redis](http://github.com/didip/bayes_on_redis) and send pull requests.
