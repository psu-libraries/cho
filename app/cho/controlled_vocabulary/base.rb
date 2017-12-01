# frozen_string_literal: true

module ControlledVocabulary
  class Base
    def lookup(_value)
      raise Error.new('ControlledVocabulary.lookup is abstract. Children must implement.')
    end
  end
end
