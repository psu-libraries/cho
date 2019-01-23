# frozen_string_literal: true

# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests
# from the Blacklight Vue front-end.

# @note See https://github.com/cyu/rack-cors for more information
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :head, :options]
  end
end
