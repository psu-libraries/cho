# frozen_string_literal: true

module Work::WithErrorMessages
  def error_messages
    errors.details.map do |key, values|
      data_dictionary_field = DataDictionary::Field.where(label: key.to_s).first
      label = key
      if data_dictionary_field.present? && data_dictionary_field.display_name.present?
        label = data_dictionary_field.display_name
      end
      values.map { |value| errors.full_message(label, value[:error]) }
    end.flatten
  end
end
