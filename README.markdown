# What is BayesOnRedis?

Bayesian classifier on top of Redis

## Why on Redis?

[Redis](http://redis.io/) is a persistent, in-memory, key-value store with support for various data structures such as lists, sets, and ordered sets.
All these data types can be manipulated with atomic operations to push/pop elements, add/remove elements, perform server-side union, intersection, difference between sets, and so forth.

Because of Redis' properties:

 * It is extremely easy to implement simple algorithm such as bayesian filter.

 * The persistence of Redis means that the Bayesian implementation can be used in real production environment.

 * Even though I don't particularly care about performance at the moment, Redis benchmarks give me confidence that the implementation can scale to relatively large training data.

## How to install? (Ruby version)

    gem install bayes_on_redis

## Getting started

    # Create instance of BayesOnRedis and pass your Redis information.
    # Of course, use real sentences for much better accuracy.
    # Unless if you want to train spam related things.
    bor = BayesOnRedis.new(:redis_host => '127.0.0.1', :redis_port => 6379, :redis_db => 0)

    # Teach it
    bor.train "good", "sweet awesome kick-ass cool pretty smart"
    bor.train "bad", "sucks lame boo death bankrupt loser sad"

    # Then ask it to classify text.
    bor.classify("awesome kick-ass ninja can still be lame.")

## for Pythonistas

BayesOnRedis is also available in Python. With the same API.

    easy_install bayes_on_redis



## Contributing

[Fork http://github.com/didip/bayes_on_redis](http://github.com/didip/bayes_on_redis) and send pull requests.
