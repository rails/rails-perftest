# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rails/perftest/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yves Senn"]
  gem.email         = ["yves.senn@gmail.com"]
  gem.description   = %q{Rails performance tests (removed from core in Rails 4.0)}
  gem.summary       = %q{ActionDispatch::PerformanceTest, ActiveSupport::Testing::Performance extracted from Rails.}
  gem.homepage      = "https://github.com/rails/rails-perftest"
  gem.license       = "MIT"

  gem.files         = [".gitignore",".travis.yml","Gemfile","Gemfile.lock","LICENSE","README.md","Rakefile","bin/rake","exe/perftest","gemfiles/Gemfile-rails-4.0","gemfiles/Gemfile-rails-4.1","lib/generators/rails/app/templates/test/performance/browsing_test.rb","lib/generators/rails/performance_test/USAGE","lib/generators/rails/performance_test/performance_test_generator.rb","lib/generators/rails/performance_test/templates/performance_test.rb","lib/rails-perftest.rb","lib/rails/performance_test_help.rb","lib/rails/perftest/action_controller.rb","lib/rails/perftest/action_controller/performance_test.rb","lib/rails/perftest/action_dispatch.rb","lib/rails/perftest/action_dispatch/performance_test.rb","lib/rails/perftest/active_support/testing/performance.rb","lib/rails/perftest/active_support/testing/performance/jruby.rb","lib/rails/perftest/active_support/testing/performance/rubinius.rb","lib/rails/perftest/active_support/testing/performance/ruby.rb","lib/rails/perftest/commands.rb","lib/rails/perftest/commands/benchmarker.rb","lib/rails/perftest/commands/profiler.rb","lib/rails/perftest/railtie.rb","lib/rails/perftest/railties/testing.tasks","lib/rails/perftest/version.rb","rails-perftest.gemspec","rails-perftest.gemspec.erb","test/generators/generators_test_helper.rb","test/generators/performance_test_generator_test.rb","test/helper.rb","test/performance_test.rb"]
  gem.bindir       = "exe"
  gem.executables   = ["perftest"]
  gem.test_files    = ["test/generators/generators_test_helper.rb","test/generators/performance_test_generator_test.rb","test/helper.rb","test/performance_test.rb"]
  gem.name          = "rails-perftest"
  gem.require_paths = ["lib"]
  gem.version       = Rails::Perftest::VERSION

  gem.add_development_dependency 'actionmailer', '>= 5.2'
  gem.add_development_dependency 'actionpack', '>= 5.2'
  gem.add_development_dependency 'activemodel', '>= 5.2'
  gem.add_development_dependency 'activerecord', '>= 5.2'
  gem.add_development_dependency 'minitest', '>= 3'
  gem.add_development_dependency 'railties', '>= 5.2'
  gem.add_development_dependency 'ruby-prof', '>= 0.12.1'
  gem.add_development_dependency 'sqlite3', '>= 1.3'
end
