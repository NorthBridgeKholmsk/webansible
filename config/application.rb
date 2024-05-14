require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webansible
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.i18n.default_locale = :ru
    config.encoding = "utf-8"
    config.active_record.encryption.support_unencrypted_data = true
    config.active_record.encryption.primary_key = "1jy9MkrRAT600lCCZ5mmAZsnvao7cv3u"
    config.active_record.encryption.deterministic_key = "tGGhZGqam7ZGhvvktLw9Yhp5m1BmgF5d"
    config.active_record.encryption.key_derivation_salt = "N91KN4A2vlNiZmj7xJQAzTI7rWFnQhuo"
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
