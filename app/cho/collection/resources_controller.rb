# frozen_string_literal: true

module Collection
  class ResourcesController < ApplicationController
    include Blacklight::Catalog
    include Blacklight::DefaultComponentConfiguration

    copy_blacklight_config_from(CatalogController)

    helper UrlHelperBehavior, LocalHelper

    # @note Use Blacklight's views and override them locally. We spell out the exact paths
    #       to use for views because of the module namespace.
    def self._prefixes
      ['application', 'collection/resources', 'catalog']
    end

    configure_blacklight do |config|
      config.search_builder_class = ResourcesSearchBuilder
    end
  end
end
