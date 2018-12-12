# frozen_string_literal: true

module ControlledVocabulary
  class Base
    def self.list
      raise Error.new('ControlledVocabulary.list is abstract. Children must implement.')
    end
  end
end
