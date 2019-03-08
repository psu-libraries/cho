# frozen_string_literal: true

module CatalogSearchBehavior
  extend ActiveSupport::Concern

  included do
    self.default_processor_chain += [:show_works_or_works_that_contain_files]
  end

  # show both works that match the query and works that contain files that match the query
  # copied from ScholarSphere from an updated Hyrax
  # version: https://github.com/psu-stewardship/scholarsphere/blob/develop/app/search_builders/search_builder.rb#L12
  def show_works_or_works_that_contain_files(solr_parameters)
    return if blacklight_params[:q].blank?

    solr_parameters[:user_query] = blacklight_params[:q]
    solr_parameters[:q] = new_query
    solr_parameters[:defType] = 'lucene'
  end

  private

    # the {!lucene} gives us the OR syntax
    def new_query
      "{!lucene}#{internal_query(query_all_query_fields)} "\
      "#{internal_query(search_metadata_from_file_sets)} "\
      "#{internal_query(search_extracted_text_from_files)}"
    end

    # @note The _query_ allows for another parser, i.e. dismax.
    def internal_query(query_value)
      "_query_:\"#{query_value}\""
    end

    # @note The {!dismax} causes the query to go against the query fields. This is functionally equivalent
    #   to q=*:user_query where user_query is the query string submitted by the user, and the fields being
    #   searched are specified in the qf parameter.
    def query_all_query_fields
      '{!dismax v=$user_query}'
    end

    # @note Extends the search to include the fields from file sets attached to work.
    def search_metadata_from_file_sets
      "{!join from=join_id_ssi to=member_ids_ssim}#{query_all_query_fields}"
    end

    # @note Extends to search to include text content extracted from files in the work. This is functionally
    #   equivalent to:
    #     q={!join from=join_id_ssi to=member_ids_ssim}all_text_timv:user_query
    #   where user_query is the query string submitted by the user.
    def search_extracted_text_from_files
      '{!join from=join_id_ssi to=member_ids_ssim}{!dismax qf=all_text_timv v=$user_query}'
    end
end
