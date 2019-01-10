# frozen_string_literal: true

# An internal CHO resource used for defining a new instance of {DataDictionary::Field} and changing its attributes.
# Metadata fields are not indexed in Solr and are only persisted in Postgres via
# the {Postgres::SingularMetadataAdapter}.
module Schema
  class MetadataField < DataDictionary::Field
    attribute :order_index, Valkyrie::Types::Integer
    attribute :data_dictionary_field_id, Valkyrie::Types::ID.optional
    attribute :work_type, Valkyrie::Types::String

    class << self
      def initialize_from_data_dictionary_field(data_dictionary_field, schema_field_config = {})
        attributes = data_dictionary_field.attributes.except(:created_at, :updated_at, :internal_resource, :id)
        attributes = merge_attributes(attributes, schema_field_config)
        field = new(attributes)
        field.data_dictionary_field_id = data_dictionary_field.id
        field
      end

      private

        def merge_attributes(data_dictionary_attributes, schema_field_config)
          return data_dictionary_attributes if schema_field_config.blank?

          safe_schema_field_config = schema_field_config.symbolize_keys
            .reject { |key, _value| reserved_keys.include?(key) }
          data_dictionary_attributes.merge(safe_schema_field_config)
        end

        def reserved_keys
          [:label, :requirement_designation, :core_field]
        end
     end
  end
end
