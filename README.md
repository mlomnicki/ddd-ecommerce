[![Build Status](https://travis-ci.org/mlomnicki/ddd-ecommerce.svg?branch=master)](https://travis-ci.org/mlomnicki/ddd-ecommerce)
[![Code Climate](https://codeclimate.com/github/mlomnicki/ddd-ecommerce/badges/gpa.svg)](https://codeclimate.com/github/mlomnicki/ddd-ecommerce)

# DDD e-commerce

# Running tests

    $ rake

    $ mutant --use rspec "Sales::Domain*"
    $ mutant --use rspec "Sales::Application*"

# Credits

* Mirek Pragłowski for his [cqrs-es-sample](https://github.com/mpraglowski/cqrs-es-sample-with-res)
