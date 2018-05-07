# frozen_string_literal: true

class Memory::SingularDeleteTrackingBuffer < Valkyrie::Persistence::DeleteTrackingBuffer
  def persister
    @persister ||= Persister.new(self)
  end

  class Persister < Memory::SingularPersister
    attr_reader :deletes
    def initialize(*args)
      @deletes = []
      super
    end

    def delete(resource:)
      @deletes << resource
      super
    end
  end
end
