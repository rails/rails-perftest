begin
  require 'ruby-prof'
rescue LoadError
  $stderr.puts 'Specify ruby-prof as application\'s dependency in Gemfile to run benchmarks.'
  raise
end

module ActiveSupport
  module Testing
    module Performance
      DEFAULTS.merge!(
        if ENV["BENCHMARK_TESTS"]
          { :metrics => [:wall_time, :memory, :objects, :gc_runs, :gc_time] }
        else
          { :min_percent => 0.01,
            :metrics => [:process_time, :memory, :objects],
            :formats => [:flat, :graph_html, :call_tree, :call_stack] }
        end).freeze

      protected
        remove_method :run_gc
        def run_gc
          GC.start
        end

      class Profiler < Performer
        def initialize(*args)
          super
          @supported = @metric.measure_mode rescue false
        end

        remove_method :run
        def run
          return unless @supported

          RubyProf.measure_mode = @metric.measure_mode
          RubyProf.start
          RubyProf.pause
          full_profile_options[:runs].to_i.times { run_test(@metric, :profile) }
          @data = RubyProf.stop
          @total = @data.threads.sum(0) { |thread| thread.methods.max.total_time }
        end

        remove_method :record
        def record
          return unless @supported

          klasses = full_profile_options[:formats].map { |f| RubyProf.const_get("#{f.to_s.camelize}Printer") }.compact

          klasses.each do |klass|
            fname = output_filename(klass)
            printer = klass.new(@data)
            options = full_profile_options.slice(:min_percent)
            path = File.dirname(fname)
            FileUtils.mkdir_p(path)
            if printer.is_a?(RubyProf::CallTreePrinter) && RubyProf::VERSION >= "0.16"
              printer.print(options.merge(:path => path))
              call_grind_file = Dir.glob("#{path}/*callgrind.out*").first
              File.rename(call_grind_file, fname)
            else
              File.open(fname, 'wb') do |file|
                printer.print(file, options)
              end
            end
          end
        end

        protected
          def output_filename(printer_class)
            suffix =
              case printer_class.name.demodulize
                when 'FlatPrinter';                 'flat.txt'
                when 'FlatPrinterWithLineNumbers';  'flat_line_numbers.txt'
                when 'GraphPrinter';                'graph.txt'
                when 'GraphHtmlPrinter';            'graph.html'
                when 'GraphYamlPrinter';            'graph.yml'
                when 'CallTreePrinter';             'tree.txt'
                when 'CallStackPrinter';            'stack.html'
                when 'DotPrinter';                  'graph.dot'
                else printer_class.name.sub(/Printer$/, '').underscore
              end

            "#{super()}_#{suffix}"
          end
      end

      module Metrics
        class Base
          def measure_mode
            self.class::Mode
          end

          remove_method :profile
          def profile
            RubyProf.resume
            yield
          ensure
            RubyProf.pause
          end

          protected
            remove_method :with_gc_stats
            def with_gc_stats
              GC::Profiler.enable
              GC.start
              yield
            ensure
              GC::Profiler.disable
            end
        end

        class ProcessTime < Time
          Mode = RubyProf::PROCESS_TIME if RubyProf.const_defined?(:PROCESS_TIME)

          def measure
            RubyProf.measure_mode = Mode
            super
          end
        end

        class WallTime < Time
          Mode = RubyProf::WALL_TIME if RubyProf.const_defined?(:WALL_TIME)

          def measure
            RubyProf.measure_mode = Mode
            super
          end
        end

        class CpuTime < Time
          # from ruby-prof changelog: 'Remove the CPU_TIME measurement mode since it duplicates the PROCESS_TIME mode and required inline assembly code'
          Mode = RubyProf::PROCESS_TIME if RubyProf.const_defined?(:PROCESS_TIME)

          def measure
            RubyProf.measure_mode = Mode
            super
          end
        end

        class Memory < DigitalInformationUnit
          Mode = RubyProf::MEMORY if RubyProf.const_defined?(:MEMORY)

          # Ruby 1.9 + GCdata patch
          if GC.respond_to?(:malloc_allocated_size)
            def measure
              RubyProf.measure_mode = Mode
              GC.malloc_allocated_size
            end
          end
        end

        class Objects < Amount
          Mode = RubyProf::ALLOCATIONS if RubyProf.const_defined?(:ALLOCATIONS)

          # Ruby 1.9 + GCdata patch
          if GC.respond_to?(:malloc_allocations)
            def measure
              GC.malloc_allocations
            end
          end
        end

        class GcRuns < Amount
          Mode = RubyProf::GC_RUNS if RubyProf.const_defined?(:GC_RUNS)

          def measure
            GC.count
          end
        end

        class GcTime < Time
          Mode = RubyProf::GC_TIME if RubyProf.const_defined?(:GC_TIME)

          def measure
            GC::Profiler.total_time
          end
        end
      end
    end
  end
end
