require 'rails/railtie'

module Rails
  module PerformanceTest
    class Railtie < ::Rails::Railtie

      rake_tasks do
        load 'rails/perftest/railties/testing.tasks'
      end

      initializer "action_dispatch.performance_test" do
        ActiveSupport.on_load(:action_controller) do
          require "rails/perftest/action_dispatch"
          require "rails/perftest/action_controller"
        end
      end

    end
  end
end
