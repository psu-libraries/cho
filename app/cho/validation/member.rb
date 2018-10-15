# frozen_string_literal: true

module Validation
  class Member
    attr_reader :id

    def initialize(id)
      @id = Valkyrie::ID.new(id)
    end

    def exists?
      exists_by_id? || exists_by_alternate_id?
    end

    private

      def exists_by_id?
        Valkyrie.config.metadata_adapter.query_service.find_by(id: id)
        true
      rescue Valkyrie::Persistence::ObjectNotFoundError
        false
      end

      def exists_by_alternate_id?
        Valkyrie.config.metadata_adapter.query_service.find_by_alternate_identifier(alternate_identifier: id)
        true
      rescue Valkyrie::Persistence::ObjectNotFoundError
        false
      end
  end
end
