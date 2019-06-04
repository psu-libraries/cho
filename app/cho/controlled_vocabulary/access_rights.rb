# frozen_string_literal: true

module ControlledVocabulary
  class AccessRights < Base
    def self.list(*)
      Repository::AccessControls::AccessLevel.names
    end
  end
end
