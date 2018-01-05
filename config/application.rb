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

    # Classes such as WorkObject and shared modules are not namespaced and must be loaded explicitly.
    config.eager_load_paths += [
      Rails.root.join('app', 'cho', 'work_object'),
      Rails.root.join('app', 'cho', 'shared'),
      Rails.root.join('app', 'cho', 'collection')
    ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
