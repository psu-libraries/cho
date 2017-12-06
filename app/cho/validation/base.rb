# frozen_string_literal: true

module Validation
  class Base
    def validate(_field)
      raise Error, 'Validation.validate is abstract. Children must implement.'
    end
  end
end
