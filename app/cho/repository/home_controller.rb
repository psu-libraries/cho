# frozen_string_literal: true

module Repository
  class HomeController < ApplicationController
    layout 'home'

    skip_authorize_resource only: :index

    def index; end
  end
end
