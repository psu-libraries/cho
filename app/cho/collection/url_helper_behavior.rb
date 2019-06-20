# frozen_string_literal: true

# @note Overrides Blacklight::UrlHelperBehavior in Collection::ResourcesController
module Collection::UrlHelperBehavior
  # @note Blacklight can't determine the tracking path because we're using nested routes, so we're just hard coding it.
  def controller_tracking_method
    'track_archival_collection_resources_path'
  end

  # @note urls should be within the scope of the Collection::ResourcesController. This could have been accomplished
  # in Blacklight::SearchState.url_for_document by using a config.show.route setting, but we couldn't figure out
  # how to do it.
  def url_for_document(doc, options = {})
    return if doc.nil?

    archival_collection_resource_path(options.merge(id: doc.id))
  end
end
