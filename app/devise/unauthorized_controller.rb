# frozen_string_literal: true

# @note this is a simple page to render when the user is not yet authenticated. It should be
#   replaced later with a more complete landing page.
class UnauthorizedController < Devise::FailureApp
  def respond
    self.status = 401
    self.response_body = '<h1>Unauthorized</h1><p>Please <a href="/devise_remote/login">login</a></p>'
  end
end
