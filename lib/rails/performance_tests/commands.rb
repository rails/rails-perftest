ARGV << '--help' if ARGV.empty?

help_message = <<-EOT
Usage: rperf COMMAND [ARGS]

 benchmarker  See how fast a piece of code runs
 profiler     Get profile information from a piece of code

All commands can be run with -h (or --help) for more information.
EOT

command = ARGV.shift

case command

when 'benchmarker', 'profiler'
  require APP_PATH
  Rails.application.require_environment!
  require "rails/performance_tests/commands/#{command}"

when '-h', '--help'
  puts help_message
else
  puts "Error: Command '#{command}' not recognized"
  if %x{rake #{command} --dry-run 2>&1 } && $?.success?
    puts "Did you mean: `$ rake #{command}` ?\n\n"
  end
  puts help_message
  exit(1)
end
