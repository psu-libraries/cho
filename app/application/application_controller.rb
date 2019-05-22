# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include DeviseRemote::HttpHeaderAuthenticatableBehavior

  helper LocalHelperBehavior, LayoutHelperBehavior
  helper Openseadragon::OpenseadragonHelper

  layout 'blacklight'

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |_exception|
    render file: Rails.root.join('public', '403.html'),
           status: 403,
           layout: false
  end

  rescue_from Blacklight::Exceptions::RecordNotFound do |_exception|
    render file: Rails.root.join('public', '404.html'),
           status: 404,
           layout: false
  end
end
