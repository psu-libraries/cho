# frozen_string_literal: true

module ControlledVocabulary
  class Collections < Base
    def self.list(*)
      (Collection::Archival.all + Collection::Library.all)
    end
  end
end
