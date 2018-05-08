# frozen_string_literal: true

module Memory
  class SingularMetadataAdapter < Valkyrie::Persistence::Memory::MetadataAdapter
    # @return [Valkyrie::Persistence::Memory::Persister] A memory persister for
    #   this adapter.
    def persister
      Memory::SingularPersister.new(self)
    end
  end
end
