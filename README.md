[![Build Status](https://travis-ci.org/mlomnicki/ddd-shop.svg?branch=master)](https://travis-ci.org/mlomnicki/ddd-shop)

# DDD Shop

# Running tests

    $ rake

    $ mutant --use rspec "Sales::Domain*"
    $ mutant --use rspec "Sales::Application*"
