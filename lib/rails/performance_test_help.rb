ActionController::Base.perform_caching = true
ActiveSupport::Dependencies.mechanism = :require if ActiveSupport::Dependencies.respond_to?(:mechanism=)
Rails.logger.level = ActiveSupport::Logger::INFO
