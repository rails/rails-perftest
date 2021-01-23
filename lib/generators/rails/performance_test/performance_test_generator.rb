module Rails
  module Generators
    class PerformanceTestGenerator < NamedBase # :nodoc:
      check_class_collision suffix: "Test"

      source_root File.expand_path("../templates", __FILE__)

      def create_performance_test_file
        template 'performance_test.rb', File.join('test/performance', class_path, "#{file_name}_test.rb")
      end

      def create_test_helper_file
        new_filename = File.join('test', 'test_helper.rb')
        template 'test_helper.rb', new_filename unless File.exist?(new_filename)
      end
    end
  end
end
