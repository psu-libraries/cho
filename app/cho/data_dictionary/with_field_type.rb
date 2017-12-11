# frozen_string_literal: true

module DataDictionary::WithFieldType
  extend ActiveSupport::Concern

  FieldTypes = Valkyrie::Types::String.enum('string', 'text', 'numeric', 'date')

  included do
    attribute :field_type, FieldTypes
  end

  def string!
    self.field_type = 'string'
  end

  def string?
    field_type == 'string'
  end

  def text!
    self.field_type = 'text'
  end

  def text?
    field_type == 'text'
  end

  def numeric!
    self.field_type = 'numeric'
  end

  def numeric?
    field_type == 'numeric'
  end

  def date!
    self.field_type = 'date'
  end

  def date?
    field_type == 'date'
  end
end
