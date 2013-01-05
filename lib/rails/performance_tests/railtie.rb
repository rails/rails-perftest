require 'rails/railtie'

module Rails
  module PerformanceTest
    class Railtie < ::Rails::Railtie

      rake_tasks do
        load 'rails/performance_tests/railties/testing.tasks'
      end

      initializer "action_dispatch.performance_test" do
        ActiveSupport.on_load(:action_controller) do
          require "rails/performance_tests/action_dispatch"
          require "rails/performance_tests/action_controller"
        end
      end

    end
  end
end
