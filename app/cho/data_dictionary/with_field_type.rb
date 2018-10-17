# frozen_string_literal: true

module DataDictionary::WithFieldType
  extend ActiveSupport::Concern

  FieldTypes = Valkyrie::Types::String.enum('string', 'text', 'numeric', 'date', 'valkyrie_id', 'alternate_id')

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

  def valkyrie_id!
    self.field_type = 'valkyrie_id'
  end

  def valkyrie_id?
    field_type == 'valkyrie_id'
  end

  def alternate_id!
    self.field_type = 'alternate_id'
  end

  def alternate_id?
    field_type == 'alternate_id'
  end
end
