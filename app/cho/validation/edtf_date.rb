# frozen_string_literal: true

module Validation
  class EDTFDate < Base
    def validate(field_value)
      @errors = []
      return true if field_value.blank?

      Array.wrap(field_value).each do |value|
        date = Date.edtf(value)
        errors << "Date #{value} is not a valid EDTF date" unless date
      end
      errors.empty?
    end
  end
end
