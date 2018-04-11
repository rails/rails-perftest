require 'rails/perftest/active_support/testing/performance'

module ActionDispatch
  # An integration test that runs a code profiler on your test methods.
  # Profiling output for combinations of each test method, measurement, and
  # output format are written to your tmp/performance directory.
  class PerformanceTest < ActionDispatch::IntegrationTest
    include ActiveSupport::Testing::Performance

    minitest_version = Gem.loaded_specs["minitest"].version

    if minitest_version < Gem::Version.create('5.0.0')
      include Minitest4AndLower
    elsif minitest_version < Gem::Version.create('5.11.0')
      include Minitest5
    else
      include Minitest511AndGreater
    end
  end
end
