# frozen_string_literal: true

module Schema
  class WorkTypeConfiguration
    attr_reader :schema_configuration, :work_type, :fields

    def initialize(schema_configuration:, work_type:)
      @schema_configuration = schema_configuration
      @work_type = work_type
      @fields = initialize_fields
    end

    def generate_metadata_schema
      schema_fields = initialize_schema_fields

      metadata_schema = Schema::Metadata.new(
        label: work_type,
        core_fields: schema_configuration.core_field_ids,
        fields: schema_fields.map(&:id)
      )
      find_or_save(metadata_schema)
    end

    def generate_work_type
      metadata_schema = Schema::Metadata.find_using(label: work_type).first
      return nil if metadata_schema.blank?

      work_type_schema = Work::Type.new(
        label: work_type,
        metadata_schema_id: metadata_schema.id,
        processing_schema: 'default',
        display_schema: 'default'
      )
      find_or_save(work_type_schema)
    end

    def initialize_schema_fields
      return [] if fields.nil?

      fields.map do |field, attributes|
        data_dictionary_field = DataDictionary::Field.where(label: field).first
        metadata_field = Schema::MetadataField.initialize_from_data_dictionary_field(data_dictionary_field, attributes)
        metadata_field.order_index = (attributes.fetch('order_index', '1') + schema_configuration.core_field_count)
        find_or_save(metadata_field)
      end
    end

    private

      def change_set_persister
        @change_set_persister ||= ChangeSetPersister.new(metadata_adapter: Valkyrie.config.metadata_adapter, storage_adapter: nil)
      end

      def find_or_save(resource)
        change_set_persister.update_or_create(resource, unique_attribute: :label)
      end

      def initialize_fields
        work_type_config = schema_configuration.schema_config.select { |config| config.fetch('schema') == work_type }
        return nil if work_type_config.blank?

        work_type_config.first.fetch('fields')
      end
  end
end
