# frozen_string_literal: true

module ControlledVocabulary
  class Agents < Base
    def self.list(*)
      Agent::Resource.all
    end
  end
end
