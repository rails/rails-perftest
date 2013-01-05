require 'rails/railtie'

module Rails
  module PerformanceTest
    class Railtie < ::Rails::Railtie

      initializer "action_dispatch.performance_test" do
        ActiveSupport.on_load(:action_controller) do
          require "rails/performance_tests/action_dispatch/performance_test"
        end
      end

    end
  end
end
