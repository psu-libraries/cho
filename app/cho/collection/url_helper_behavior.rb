# frozen_string_literal: true

# @note Overrides Blacklight::UrlHelperBehavior in Collection::ResourcesController
module Collection::UrlHelperBehavior
  # @note Blacklight can't determine the tracking path because we're nesting it. So we just hard code it.
  def controller_tracking_method
    'track_archival_collection_resources_path'
  end
end
