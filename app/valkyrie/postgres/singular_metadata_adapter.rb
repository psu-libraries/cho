# frozen_string_literal: true

module Postgres
  class SingularMetadataAdapter
    # @return [Class] {Valkyrie::Persistence::Postgres::Persister}
    def persister
      SingularPersister.new(adapter: self)
    end

    # @return [Class] {Valkyrie::Persistence::Postgres::QueryService}
    def query_service
      @query_service ||= Valkyrie::Persistence::Postgres::QueryService.new(resource_factory: resource_factory)
    end

    # @return [Class] {Valkyrie::Persistence::Postgres::ResourceFactory}
    def resource_factory
      Valkyrie::Persistence::Postgres::ResourceFactory.new(adapter: self)
    end

    def id
      @id ||= Valkyrie::ID.new(Digest::MD5.hexdigest(self.class.to_s))
    end
  end
end
