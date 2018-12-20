# frozen_string_literal: true

module Collection
  class TypeIndexer
    attr_reader :resource
    def initialize(resource:)
      @resource = resource
    end

    def to_solr
      return {} unless resource.class.to_s.split('::').include?('Collection')

      {
        collection_type_ssim: resource.model_name.human.titleize
      }
    end
  end
end
