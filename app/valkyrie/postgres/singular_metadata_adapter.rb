# frozen_string_literal: true

module Postgres
  class SingularMetadataAdapter
    # @return [Class] {Valkyrie::Persistence::Postgres::Persister}
    def persister
      SingularPersister.new(adapter: self)
    end

    # @return [Class] {Valkyrie::Persistence::Postgres::QueryService}
    def query_service
      @query_service ||= Valkyrie::Persistence::Postgres::QueryService.new(adapter: self)
    end

    # @return [Class] {Valkyrie::Persistence::Postgres::ResourceFactory}
    def resource_factory
      Valkyrie::Persistence::Postgres::ResourceFactory
    end
  end
end
