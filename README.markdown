# bayes_on_redis

Bayesian classifier on top of Redis

## Why on Redis?

Redis is perfect for building fast bayesian filter.

## Getting started

    # Create instance of BayesOnRedis and pass your Redis information.
    bor = BayesOnRedis.new(:redis_host => '127.0.0.1', :redis_port => 6379, :redis_db => 5)

    # Teach it
    bor.train "good", "sweet awesome kick-ass cool pretty smart"
    bor.train "bad", "sucks lame boo death bankrupt loser sad"

    # Then ask it to classify text.
    bor.classify_for_human("awesome kick-ass ninja can still be lame.")

## Contributing

[Fork the project](http://github.com/didip/bayes_on_redis) and send pull requests.
