# frozen_string_literal: true

class Solr::SingularPersister < Valkyrie::Persistence::Solr::Persister
  def repository(resources)
    Solr::SingularRepository.new(resources: resources, connection: connection, resource_factory: resource_factory)
  end
end
