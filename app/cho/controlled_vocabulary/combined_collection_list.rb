# frozen_string_literal: true

module ControlledVocabulary
  class CombinedCollectionList < Base
    def self.archival_library_list
      (Collection::Archival.all + Collection::Library.all)
    end
  end
end
