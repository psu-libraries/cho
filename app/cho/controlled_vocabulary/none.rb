# frozen_string_literal: true

module ControlledVocabulary
  class None < Base
    def lookup(_value)
      []
    end
  end
end
