# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  self.default_processor_chain += [:show_works_or_works_that_contain_files, :show_only_works_and_collections]

  # show both works that match the query and works that contain files that match the query
  # copied from ScholarSphere from an updated Hyrax
  # version: https://github.com/psu-stewardship/scholarsphere/blob/develop/app/search_builders/search_builder.rb#L12
  def show_works_or_works_that_contain_files(solr_parameters)
    return if blacklight_params[:q].blank?
    solr_parameters[:user_query] = blacklight_params[:q]
    solr_parameters[:q] = new_query
    solr_parameters[:defType] = 'lucene'
  end

  # Do not include files and file sets in the search results
  def show_only_works_and_collections(solr_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << 'internal_resource_ssim:("Collection::Archival" OR "Collection::Library"' \
                             'OR "Collection::Curated" OR "Work::Submission")'
  end

  private

    # the {!lucene} gives us the OR syntax
    def new_query
      "{!lucene}#{internal_query(dismax_query)} #{internal_query(join_from_work_to_file_set)}"
    end

    # the _query_ allows for another parser (aka dismax)
    def internal_query(query_value)
      "_query_:\"#{query_value}\""
    end

    # the {!dismax} causes the query to go against the query fields
    def dismax_query
      '{!dismax v=$user_query}'
    end

    def join_from_work_to_file_set
      "{!join from=join_id_ssi to=file_set_ids_ssim}#{dismax_query}"
    end
end
