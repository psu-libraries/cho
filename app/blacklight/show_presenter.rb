# frozen_string_literal: true

class ShowPresenter < Blacklight::ShowPresenter
  def thumbnail
    @thumbnail ||= ThumbnailPresenter.new(document, view_context, view_config)
  end
end
