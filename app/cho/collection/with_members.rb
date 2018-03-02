# frozen_string_literal: true

module Collection
  module WithMembers
    # @return [Array<Valkyrie::Resource>]
    def members
      query_service.find_inverse_references_by(resource: self, property: 'member_of_collection_ids').to_a
    end

    private

      def query_service
        @query_service ||= Valkyrie::MetadataAdapter.find(:index_solr).query_service
      end
  end
end
