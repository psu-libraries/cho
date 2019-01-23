# frozen_string_literal: true

module Validation
  class EDTFDate < Base
    def validate(field_value)
      @errors = []
      return true if field_value.blank?

      Array.wrap(field_value).each do |value|
        date = parse(value) || Date.edtf(value)
        errors << "Date #{value} is not a valid EDTF date" unless date
      end
      errors.empty?
    end

    private

      def parse(date)
        Date.parse(date)
      rescue ArgumentError
        nil
      end
  end
end
