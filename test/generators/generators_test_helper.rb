require 'minitest/autorun'

require 'fileutils'

require 'rails/all'
require 'rails/generators'
require 'rails/generators/test_case'

module TestApp
  class Application < Rails::Application
  end
end

# Call configure to load the settings from
# Rails.application.config.generators to Rails::Generators
Rails.application.load_generators
