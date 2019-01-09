# frozen_string_literal: true

module Validation
  class ResourceExists < Base
    def validate(field_value)
      @errors = []
      return true if field_value.blank?

      member = Validation::Member.new(field_value)
      return true if member.exists?

      @errors << "#{field_value} does not exist"
      false
    end
  end
end
