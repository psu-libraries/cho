# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include CatalogSearchBehavior

  self.default_processor_chain += [:show_only_works_and_collections]

  # Do not include files and file sets in the search results
  def show_only_works_and_collections(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'internal_resource_ssim:("Collection::Archival" OR "Collection::Library"' \
                             'OR "Collection::Curated" OR "Work::Submission")'
  end
end
