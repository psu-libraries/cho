# frozen_string_literal: true

# @note This was copied from Figgy to enable display of works within a collection's show page.
class SolrFacade
  delegate :total_pages, to: :query_response

  # @params [Blacklight::Solr::Repository] repository
  # @params [Hash] query parameters for Solr
  # @params [Integer] current_page
  # @params [Integer] per_page
  def initialize(repository:, query:, current_page: 1, per_page: 10)
    current_page = current_page.blank? ? 1 : current_page.to_i
    per_page = per_page.blank? ? 10 : per_page.to_i
    @repository = repository
    @query = query
    @current_page = current_page
    @per_page = per_page
  end

  # @return [Blacklight::Solr::Response]
  def query_response
    @query_response ||= @repository.search(@query)
  end

  # @return [Array<SolrDocument>]
  def members
    query_response.documents
  end
end
