# frozen_string_literal: true

module Validation
  class Base
    attr_accessor :errors

    def validate(_field)
      @errors
      raise Error, 'Validation.validate is abstract. Children must implement.'
    end
  end
end
