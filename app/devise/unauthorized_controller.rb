# frozen_string_literal: true

class UnauthorizedController < Devise::FailureApp
  def respond
    self.status = 401
    self.response_body = '<h1>Unauthorized</h1><p>Please <a href="/devise_remote/login">login</a></p>'
  end
end
