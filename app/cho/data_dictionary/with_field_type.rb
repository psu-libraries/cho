# frozen_string_literal: true

module DataDictionary::WithFieldType
  extend ActiveSupport::Concern

  TYPES = %w(
    string
    text
    numeric
    date
    valkyrie_id
    alternate_id
    creator
    radio_button
  ).freeze

  FieldTypes = Valkyrie::Types::String.enum(*TYPES)

  included do
    attribute :field_type, FieldTypes
  end

  TYPES.each do |type|
    define_method "#{type}!" do
      self.field_type = type
    end

    define_method "#{type}?" do
      field_type == type
    end
  end
end
