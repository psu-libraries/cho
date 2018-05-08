# frozen_string_literal: true

module Solr
  class SingularMetadataAdapter < Valkyrie::Persistence::Solr::MetadataAdapter
    def persister
      Solr::SingularPersister.new(adapter: self)
    end
  end
end
