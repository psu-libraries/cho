# frozen_string_literal: true

# An internal CHO resource used for grouping different {Schema::MetadataField} resources and assigning them to
# a {Work::Type} resource.
# Schemas are not indexed in Solr and are only persisted in Postgres via the {Postgres::SingularMetadataAdapter}
module Schema
  class Metadata < Valkyrie::Resource
    include CommonQueries

    attribute :id, Valkyrie::Types::ID.optional
    attribute :label, Valkyrie::Types::String
    attribute :core_fields, Valkyrie::Types::Array
    attribute :fields, Valkyrie::Types::Array

    alias core_field_ids core_fields
    alias field_ids fields

    def core_fields=(new_fields)
      set_value(:core_fields, gather_field_ids(new_fields))
      @loaded_core_fields = new_fields
    end

    def fields=(new_fields)
      set_value(:fields, gather_field_ids(new_fields))
      @loaded_fields = new_fields
    end

    def loaded_core_fields
      @loaded_core_fields ||= load_fields(attributes[:core_fields])
    end

    def loaded_fields
      @loaded_fields ||= load_fields(attributes[:fields])
    end

    def field(label)
      loaded_core_fields.select { |field| field.label == label }.first ||
        loaded_fields.select { |field| field.label == label }.first
    end

    private

      def gather_field_ids(new_fields)
        new_fields.map do |field|
          unless field.is_a? Schema::MetadataField
            raise Dry::Types::ConstraintError.new("type?(Work::TemplateField, #{field.class}", field)
          end
          field.id
        end
      end

      def load_fields(id_list)
        id_list.map { |id| MetadataField.find(id) }
      end
  end
end
