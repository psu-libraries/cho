# frozen_string_literal: true

module Repository
  class DownloadsController < ApplicationController
    def download
      if resource.available?
        send_file(resource.path)
      else
        render file: 'public/404.html', status: 404, layout: false
      end
    end

    private

      def resource
        @resource ||= Download.new(id: params.fetch(:id), use: params.fetch(:use_type, nil))
      end
  end
end
