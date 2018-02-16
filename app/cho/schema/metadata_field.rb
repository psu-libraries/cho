# frozen_string_literal: true

module Schema
  class MetadataField < DataDictionary::Field
    attribute :order_index, Valkyrie::Types::Int
    attribute :data_dictionary_field_id, Valkyrie::Types::ID.optional

    def self.initialize_from_data_dictionary_field(data_dictionary_field)
      field = new(data_dictionary_field.attributes.except(:created_at, :updated_at, :internal_resource, :id))
      field.data_dictionary_field_id = data_dictionary_field.id
      field
    end
  end
end
