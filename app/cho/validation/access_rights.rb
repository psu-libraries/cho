# frozen_string_literal: true

module Validation
  class AccessRights < Base
    def validate(field_value)
      self.errors = []
      return true if field_value.blank?

      (Array.wrap(field_value) - Repository::AccessControls::AccessLevel.names).each do |invalid_level|
        errors << "#{invalid_level} is not a valid access right"
      end
      errors.empty?
    end
  end
end
