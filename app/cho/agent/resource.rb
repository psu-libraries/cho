# frozen_string_literal: true

module Agent
  class Resource < Valkyrie::Resource
    NAME_SEPARATOR = ','

    include CommonQueries

    attribute :given_name, Valkyrie::Types::String
    attribute :surname, Valkyrie::Types::String

    def to_s
      "#{given_name} #{surname}"
    end

    def display_name
      "#{surname}#{NAME_SEPARATOR} #{given_name}"
    end

    def member_ids
      @member_ids ||= load_member_ids_from_solr
    end

    private

      # @note this same information can be loaded from Postgres if you so desire:
      #   SELECT id FROM orm_resources
      #   WHERE metadata->'creator' @> '[{"agent": "#{id}"}]'
      def load_member_ids_from_solr
        solr_connection = Valkyrie::MetadataAdapter
          .find(:index_solr)
          .connection

        query = {
          q: "creator_agent_id_ssim:#{id}",
          fl: 'id'
        }

        solr_connection.get('select', params: query)
          .dig('response', 'docs')
          .map { |doc| Valkyrie::ID.new doc['id'] }
      end
  end
end
