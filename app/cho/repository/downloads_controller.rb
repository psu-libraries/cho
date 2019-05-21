# frozen_string_literal: true

module Repository
  class DownloadsController < ApplicationController
    include Blacklight::AccessControls::Catalog

    before_action :enforce_show_permissions, only: :download

    def download
      if resource.available?
        send_file(resource.path)
      else
        render file: 'public/404.html', status: 404, layout: false
      end
    end

    private

      def resource
        @resource ||= Download.new(
          id: params.fetch(:id),
          use: params.fetch(:use_type, nil),
          current_ability: Ability.new(current_user)
        )
      end
  end
end
