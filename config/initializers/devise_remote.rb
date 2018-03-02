# frozen_string_literal: true

Warden::Strategies.add(:http_header_authenticatable, Devise::Strategies::HttpHeaderAuthenticatable)

Devise.setup do |config|
  config.warden do |manager|
    manager.default_strategies(scope: :user).unshift :http_header_authenticatable
    manager.failure_app = UnauthorizedController
  end
end

DeviseRemote.setup do |config|
  # Specify the url to redirect to when a session has been destroyed and the user
  # has logged out of the remote authentication service.
  config.destroy_redirect_url = "https://webaccess.psu.edu/cgi-bin/logout?#{ENV['virtual_host']}"

  # Specify the url to redirect to once a user has authenticated to the remote servce.
  # This is ignored if there is a "user_return_to" value in the session. This enables
  # users to return to the page they were originally on if they authenticated during
  # an existing session.
  config.new_session_redirect_url = ENV['virtual_host']

  # Specify the url of your remote authentication service, such as Cosign or Shibboleth.
  config.web_access_url = "https://webaccess.psu.edu/?cosign-#{ENV['service_instance']}"
end
