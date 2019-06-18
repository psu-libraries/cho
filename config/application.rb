# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cho
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Classes in the shared directory are not namespaced and must be loaded explicitly
    config.eager_load_paths += [
      Rails.root.join('app', 'cho', 'shared')
    ]

    config.ldap_unwilling_sleep = 2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.storage_directory = Pathname.new(ENV['storage_directory']).expand_path
    config.network_ingest_directory = Pathname.new(ENV['network_ingest_directory']).expand_path
    config.extraction_directory = Pathname.new(ENV['extraction_directory']).expand_path
    config.collection_image_directory = Pathname.new(ENV['collection_image_directory']).expand_path

    # Inject new behaviors into existing classes without having to override the entire class itself.
    config.to_prepare do
      Valkyrie::Persistence::Shared::JSONValueMapper::DateValue.singleton_class.send(:prepend, DateTimeJSONValue)
    end
  end
end
