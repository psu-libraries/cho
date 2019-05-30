# frozen_string_literal: true

module ControlledVocabulary
  class AccessRights < Base
    def self.list(*)
      Repository::AccessLevel.names
    end
  end
end
