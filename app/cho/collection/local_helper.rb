# frozen_string_literal: true

module Collection::LocalHelper
  def collection_representative_image_path(document)
    Collection::RepresentativeImagePresenter.new(document).path
  end
end
