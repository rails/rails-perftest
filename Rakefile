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

specname = "rails-perftest.gemspec"
deps = `git ls-files`.split("\n") - [specname]

file specname => deps do
  files       = `git ls-files`.split("\n")
  test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  require 'erb'

  File.open specname, 'w:utf-8' do |f|
    f.write ERB.new(File.read("#{specname}.erb")).result(binding)
  end
end
task :build => specname
