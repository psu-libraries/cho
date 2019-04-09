# frozen_string_literal: true

module Collection
  module WithMembers
    # @return [Array<Valkyrie::Resource>]
    def members
      query_service
        .find_inverse_references_by(resource: self, property: 'home_collection_id')
        .to_a
        .sort_by(&:order_index)
    end

    # @return [Array<Valkyrie::ID]
    def member_ids
      members.map(&:id)
    end

    private

      def query_service
        @query_service ||= Valkyrie::MetadataAdapter.find(:index_solr).query_service
      end
  end
end
