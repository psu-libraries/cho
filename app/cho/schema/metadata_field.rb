# frozen_string_literal: true

# An internal CHO resource used for defining a new instance of {DataDictionary::Field} and changing its attributes.
# Metadata fields are not indexed in Solr and are only persisted in Postgres via
# the {Postgres::SingularMetadataAdapter}.
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
