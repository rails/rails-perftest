ORIG_ARGV = ARGV.dup

require 'minitest/autorun'

require 'active_support'

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true
