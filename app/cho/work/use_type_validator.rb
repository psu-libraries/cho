# frozen_string_literal: true

module Work
  class UseTypeValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      values = Array.wrap(value)
      bad_uris = values.reject { |v| Repository::FileUse.uris.include?(v) }
      return if bad_uris.empty? && values.present?

      record.errors.add attribute, error_message(bad_uris)
    end

    def error_message(uris)
      if uris.empty?
        'cannot be empty'
      else
        "cannot be #{uris.join(', ')}"
      end
    end
  end
end
