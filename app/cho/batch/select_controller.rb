# frozen_string_literal: true

module Batch
  class SelectController < ApplicationController
    include Blacklight::Catalog
    include Blacklight::DefaultComponentConfiguration

    copy_blacklight_config_from(CatalogController)

    helper LocalHelperBehavior, LayoutHelperBehavior

    # @note We want to use Blacklight's views and override them locally. Because of the module namespace
    #       this was creating paths such as catalog/batch. To avoid that, we spell out the exact paths
    #       to use for views.
    def self._prefixes
      ['application', 'batch', 'catalog']
    end
  end
end
