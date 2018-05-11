# frozen_string_literal: true

# Overrides the show action in {CatalogController} to build a list of member documents from a collection.
# @note This was copied from Figgy to enable display of works within a collection's show page.
module CollectionMembers
  # @note Used in conjunction with {CollectionMemberSearchBuilder} so we have access to
  #   the document resource within the search builder's {@scope}.
  def resource
    @resource ||= @document
  end

  def show
    super
    @document_facade = document_facade
  end

  private

    # Instantiates the search builder that builds a query for items that are
    # members of the current collection. This is used in the show view.
    def member_search_builder
      @member_search_builder ||= CollectionMemberSearchBuilder.new(self)
    end

    # You can override this method if you need to provide additional inputs to the search
    # builder. For example:
    #   search_field: 'all_fields'
    # @return <Hash> the inputs required for the collection member search builder
    def params_for_members_query
      params.merge(q: params[:cq])
    end

    # @return <Hash> a representation of the solr query that find the collection members
    def query_for_collection_members
      member_search_builder.with(params_for_members_query).query
    end

    def current_page
      params.fetch(:page, 1)
    end

    def per_page
      params.fetch(:per_page, 10)
    end

    def document_facade
      SolrFacade.new(
        repository: search_service.repository,
        query: query_for_collection_members,
        current_page: current_page,
        per_page: per_page
      )
    end
end
