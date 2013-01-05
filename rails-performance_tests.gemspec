# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rails/performance_tests/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yves Senn"]
  gem.email         = ["yves.senn@gmail.com"]
  gem.description   = %q{Rails performance tests (removed from core in Rails 4.0)}
  gem.summary       = %q{ActionDispatch::PerformanceTest, ActiveSupport::Testing::Performance extracted from Rails.}
  gem.homepage      = "https://github.com/rails/rails-performance_tests"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rails-performance_tests"
  gem.require_paths = ["lib"]
  gem.version       = Rails::PerformanceTests::VERSION

  gem.add_dependency 'ruby-prof'

  gem.add_development_dependency 'minitest', '>= 3'
  gem.add_development_dependency 'railties', '~> 4.0.0.beta'
  gem.add_development_dependency 'activerecord', '~> 4.0.0.beta'
  gem.add_development_dependency 'activemodel', '~> 4.0.0.beta'
  gem.add_development_dependency 'actionmailer', '~> 4.0.0.beta'
  gem.add_development_dependency 'actionpack', '~> 4.0.0.beta'
  gem.add_development_dependency 'sqlite3', '~> 1.3'
end
