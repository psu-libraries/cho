# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include DeviseRemote::HttpHeaderAuthenticatableBehavior

  layout 'blacklight'

  protect_from_forgery with: :exception
  before_action :authenticate_user!, :allow_admins

  def allow_admins
    return if current_user.admin?
    render file: 'public/401.html', status: 401, layout: false
  end
end
