# Rails::PerformanceTest

Rails performance tests (removed from core in Rails 4.0)

## Installation

Add this line to your application's Gemfile:

    gem 'rails-performance_test'

If you not using jruby or rubinius you need to add `ruby-prof` as a dependency.

    group :test do
      gem 'ruby-prof'
    end

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-performance_test

## Usage

### Generator

This gem ships with a generator for performance tests:

    $ rails g performance_test user_dashboard

### Execute the tests

There are two rake tasks to execute your performance tests:

    $ rake test:benchmark
    $ rake test:profile

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
