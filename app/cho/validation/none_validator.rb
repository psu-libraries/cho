# frozen_string_literal: true

module Validation
  class NoneValidator < Validator
    def validate(_field)
      true
    end
  end
end
