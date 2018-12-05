# frozen_string_literal: true

class ThumbnailPresenter < Blacklight::ThumbnailPresenter
  private

    def thumbnail_value_from_document(document)
      path = Array(thumbnail_field).lazy.map { |field| document.first(field) }.reject(&:blank?).first
      return if path.nil?
      "/files/#{Pathname.new(path).basename}"
    end
end
