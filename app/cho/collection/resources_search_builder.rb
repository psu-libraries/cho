# frozen_string_literal: true

module Collection
  class ResourcesSearchBuilder < Blacklight::SearchBuilder
    include Blacklight::Solr::SearchBuilderBehavior
    include CatalogSearchBehavior

    self.default_processor_chain += [:show_only_works_in_collection]

    def show_only_works_in_collection(solr_parameters)
      solr_parameters[:fq] ||= []
      solr_parameters[:fq] << "home_collection_id_ssim:id-#{blacklight_params.fetch(:archival_collection_id)}"
    end
  end
end
