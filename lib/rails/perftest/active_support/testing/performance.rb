require 'fileutils'
require 'active_support/concern'
require 'active_support/core_ext/class/delegating_attributes'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'
require 'active_support/number_helper'

module ActiveSupport
  module Testing
    module Performance
      extend ActiveSupport::Concern

      included do
        superclass_delegating_accessor :profile_options
        self.profile_options = {}
      end

      # each implementation should define metrics and freeze the defaults
      DEFAULTS =
        if ENV["BENCHMARK_TESTS"]
          { :runs => 4,
            :output => 'tmp/performance',
            :benchmark => true }
        else
          { :runs => 1,
            :output => 'tmp/performance',
            :benchmark => false }
        end

      def full_profile_options
        DEFAULTS.merge(profile_options)
      end

      def full_test_name
        "#{self.class.name}##{method_name}"
      end

      def run
        run_warmup
        if full_profile_options && metrics = full_profile_options[:metrics]
          metrics.each do |metric_name|
            if klass = Metrics[metric_name.to_sym]
              run_profile(klass.new)
            end
          end
        end

        self
      end

      def run_test(metric, mode)
        result = '.'
        begin
          run_callbacks :setup
          setup
          metric.send(mode) { __send__ method_name }
        rescue Exception => e
          result = result_code + e.message
        ensure
          begin
            teardown
            run_callbacks :teardown
          rescue Exception => e
            result = result_code + e.message
          end
        end
        result
      end

      protected
        # overridden by each implementation.
        def run_gc; end

        def run_warmup
          run_gc

          time = Metrics::Time.new
          run_test(time, :benchmark)
          puts "%s (%s warmup)" % [full_test_name, time.format(time.total)]

          run_gc
        end

        def run_profile(metric)
          klass = full_profile_options[:benchmark] ? Benchmarker : Profiler
          performer = klass.new(self, metric)

          performer.run
          puts performer.report
          performer.record
        end

      class Performer
        delegate :run_test, :full_profile_options, :full_test_name, :to => :@harness

        def initialize(harness, metric)
          @harness, @metric, @supported = harness, metric, false
        end

        def report
          if @supported
            rate = @total / full_profile_options[:runs]
            '%20s: %s' % [@metric.name, @metric.format(rate)]
          else
            '%20s: unsupported' % @metric.name
          end
        end

        protected
          def output_filename
            "#{full_profile_options[:output]}/#{full_test_name}_#{@metric.name}"
          end
      end

      # overridden by each implementation.
      class Profiler < Performer
        def time_with_block
          before = Time.now
          yield
          Time.now - before
        end

        def run;    end
        def record; end
      end

      class Benchmarker < Performer
        def initialize(*args)
          super
          @supported = @metric.respond_to?('measure')
        end

        def run
          return unless @supported

          full_profile_options[:runs].to_i.times { run_test(@metric, :benchmark) }
          @total = @metric.total
        end

        def record
          avg = @metric.total / full_profile_options[:runs].to_i
          now = Time.now.utc.xmlschema
          with_output_file do |file|
            file.puts "#{avg},#{now},#{environment}"
          end
        end

        def environment
          @env ||= [].tap do |env|
            env << "#{$1}.#{$2}" if File.directory?('.git') && `git branch -v` =~ /^\* (\S+)\s+(\S+)/
            env << rails_version if defined?(Rails::VERSION::STRING)
            env << "#{RUBY_ENGINE}-#{RUBY_VERSION}.#{RUBY_PATCHLEVEL}"
            env << RUBY_PLATFORM
          end.join(',')
        end

        protected
          if defined?(Rails::VERSION::STRING)
            HEADER = 'measurement,created_at,app,rails,ruby,platform'
          else
            HEADER = 'measurement,created_at,app,ruby,platform'
          end

          def with_output_file
            fname = output_filename

            if new = !File.exist?(fname)
              FileUtils.mkdir_p(File.dirname(fname))
            end

            File.open(fname, 'ab') do |file|
              file.puts(HEADER) if new
              yield file
            end
          end

          def output_filename
            "#{super}.csv"
          end

          def rails_version
            "rails-#{Rails::VERSION::STRING}#{rails_branch}"
          end

          def rails_branch
            if File.directory?('vendor/rails/.git')
              Dir.chdir('vendor/rails') do
                ".#{$1}.#{$2}" if `git branch -v` =~ /^\* (\S+)\s+(\S+)/
              end
            end
          end
      end

      module Metrics
        def self.[](name)
          const_get(name.to_s.camelize)
        rescue NameError
          nil
        end

        class Base
          include ActiveSupport::NumberHelper

          attr_reader :total

          def initialize
            @total = 0
          end

          def name
            @name ||= self.class.name.demodulize.underscore
          end

          def benchmark
            with_gc_stats do
              before = measure
              yield
              @total += (measure - before)
            end
          end

          # overridden by each implementation.
          def profile; end

          protected
            # overridden by each implementation.
            def with_gc_stats; end
        end

        class Time < Base
          def measure
            ::Time.now.to_f
          end

          def format(measurement)
            if measurement < 1
              '%d ms' % (measurement * 1000)
            else
              '%.2f sec' % measurement
            end
          end
        end

        class Amount < Base
          def format(measurement)
            number_to_delimited(measurement.floor)
          end
        end

        class DigitalInformationUnit < Base
          def format(measurement)
            number_to_human_size(measurement, :precision => 2)
          end
        end

        # each implementation provides its own metrics like ProcessTime, Memory or GcRuns
      end
    end
  end
end

case RUBY_ENGINE
  when 'ruby'   then require 'rails/perftest/active_support/testing/performance/ruby'
  when 'rbx'    then require 'rails/perftest/active_support/testing/performance/rubinius'
  when 'jruby'  then require 'rails/perftest/active_support/testing/performance/jruby'
  else
    $stderr.puts 'Your ruby interpreter is not supported for benchmarking.'
    exit
end
