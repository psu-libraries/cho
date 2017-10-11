# frozen_string_literal: true

module Validation
  class Validator
    def validate(_field)
      raise 'Validation.validate is abstract. Children must implement.'
    end
  end
end
