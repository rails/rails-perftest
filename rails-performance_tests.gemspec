# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rails/performance_tests/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yves Senn"]
  gem.email         = ["yves.senn@gmail.com"]
  gem.description   = %q{Rails performance tests (removed from core in Rails 4.0)}
  gem.summary       = %q{ActionDispatch::PerformanceTest, ActiveSupport::Testing::Performance extracted from Rails.}
  gem.homepage      = "https://github.com/rails/rails-performance_tests"

  gem.files         = [".gitignore","Gemfile","LICENSE","README.md","Rakefile","bin/rperf","lib/generators/rails/app/templates/test/performance/browsing_test.rb","lib/generators/rails/performance_test/USAGE","lib/generators/rails/performance_test/performance_test_generator.rb","lib/generators/test_unit/performance/performance_generator.rb","lib/generators/test_unit/performance/templates/performance_test.rb","lib/rails-performance_tests.rb","lib/rails/performance_tests/action_controller.rb","lib/rails/performance_tests/action_controller/performance_test.rb","lib/rails/performance_tests/action_dispatch.rb","lib/rails/performance_tests/action_dispatch/performance_test.rb","lib/rails/performance_tests/active_support/testing/performance.rb","lib/rails/performance_tests/active_support/testing/performance/jruby.rb","lib/rails/performance_tests/active_support/testing/performance/rubinius.rb","lib/rails/performance_tests/active_support/testing/performance/ruby.rb","lib/rails/performance_tests/commands.rb","lib/rails/performance_tests/commands/benchmarker.rb","lib/rails/performance_tests/commands/profiler.rb","lib/rails/performance_tests/railtie.rb","lib/rails/performance_tests/railties/testing.tasks","lib/rails/performance_tests/version.rb","rails-performance_tests.gemspec","test/generators/generators_test_helper.rb","test/generators/performance_test_generator_test.rb","test/helper.rb","test/performance_test.rb"]
  gem.executables   = ["rperf"]
  gem.test_files    = ["test/generators/generators_test_helper.rb","test/generators/performance_test_generator_test.rb","test/helper.rb","test/performance_test.rb"]
  gem.name          = "rails-performance_tests"
  gem.require_paths = ["lib"]
  gem.version       = Rails::PerformanceTests::VERSION

  gem.add_development_dependency 'ruby-prof'
  gem.add_development_dependency 'minitest', '>= 3'
  gem.add_development_dependency 'railties', '~> 4.0.0.beta'
  gem.add_development_dependency 'activerecord', '~> 4.0.0.beta'
  gem.add_development_dependency 'activemodel', '~> 4.0.0.beta'
  gem.add_development_dependency 'actionmailer', '~> 4.0.0.beta'
  gem.add_development_dependency 'actionpack', '~> 4.0.0.beta'
  gem.add_development_dependency 'sqlite3', '~> 1.3'
end
