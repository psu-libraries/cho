# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include DeviseRemote::HttpHeaderAuthenticatableBehavior

  helper LocalHelperBehavior, LayoutHelperBehavior

  layout 'blacklight'

  protect_from_forgery with: :exception
  authorize_resource class: false

  rescue_from CanCan::AccessDenied do |_exception|
    render file: Rails.root.join('public', '403.html'),
           status: 403,
           layout: false
  end
end
