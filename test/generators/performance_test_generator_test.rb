require 'generators/generators_test_helper'
require 'generators/rails/performance_test/performance_test_generator'

class PerformanceTestGeneratorTest < Rails::Generators::TestCase
  tests Rails::Generators::PerformanceTestGenerator
  arguments %w(dashboard)
  destination File.expand_path("../../tmp", __FILE__)

  def setup
    super
    prepare_destination
  end

  def test_performance_test_skeleton_is_created
    run_generator
    assert_file "test/performance/dashboard_test.rb", /class DashboardTest < ActionDispatch::PerformanceTest/
    assert_file "test/test_helper.rb", /class TestCase/
  end
end
