# frozen_string_literal: true

module Validation
  class Unique < Base
    def validate(field_value)
      @errors = []
      return true if field_value.blank? || unchanged_edit?

      Array.wrap(field_value).each do |value|
        member = Validation::Member.new(value)
        next if !member.exists_by_alternate_id?

        @errors << "#{value} already exists"
      end
      errors.empty?
    end

    private

      def unchanged_edit?
        return false unless change_set.resource.persisted?

        change_set.send(field) == change_set.resource.send(field)
      end
  end
end
