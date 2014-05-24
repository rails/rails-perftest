require 'rails/perftest/active_support/testing/performance'

module ActionDispatch
  # An integration test that runs a code profiler on your test methods.
  # Profiling output for combinations of each test method, measurement, and
  # output format are written to your tmp/performance directory.
  class PerformanceTest < ActionDispatch::IntegrationTest
    include ActiveSupport::Testing::Performance

    if Gem.loaded_specs["minitest"].version < Gem::Version.create('5.0.0')
      include Minitest4AndLower
    else
      include Minitest5AndGreater
    end
  end
end
