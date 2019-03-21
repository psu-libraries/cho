# frozen_string_literal: true

module Validation
  class Base
    attr_accessor :errors, :change_set, :field

    def initialize(change_set: nil, field: nil)
      @change_set = change_set
      @field = field
    end

    def validate(_field)
      raise Error, 'Validation.validate is abstract. Children must implement.'
    end
  end
end
