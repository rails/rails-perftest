#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

namespace :test do
  Rake::TestTask.new("regular") do |t|
    t.libs = ["test"]
    t.pattern = "test/*_test.rb"
    t.ruby_opts = ['-w']
  end

  Rake::TestTask.new("generators") do |t|
    t.libs = ["test"]
    t.pattern = "test/generators/*_test.rb"
    t.ruby_opts = ['-w']
  end
end

task :test => ['test:regular', 'test:generators']
task :default => :test
