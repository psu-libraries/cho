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
        core_fields: core_fields,
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
        attributes ||= {}
        data_dictionary_field = DataDictionary::Field.where(label: field).first
        metadata_field = Schema::MetadataField.initialize_from_data_dictionary_field(
          data_dictionary_field,
          attributes.merge(work_type: work_type)
        )

        change_set = Schema::MetadataFieldChangeSet.new(metadata_field)
        change_set.validate(attributes)
        change_set.order_index = field_order_index(metadata_field: metadata_field, attributes: attributes)
        change_set.sync
        find_or_save(change_set.resource)
      end
    end

    private

      def field_order_index(metadata_field:, attributes:)
        if metadata_field.core_field
          attributes.fetch('order_index', core_field_hash[metadata_field.label].order_index).to_i
        else
          (attributes.fetch('order_index', '1').to_i + core_field_count)
        end
      end

      def change_set_persister
        @change_set_persister ||= ChangeSetPersister.new(
          metadata_adapter: Valkyrie.config.metadata_adapter,
          storage_adapter: nil
        )
      end

      def find_or_save(resource)
        attributes = [:label]
        attributes << :work_type if resource.instance_of? Schema::MetadataField
        change_set_persister.update_or_create(resource, unique_attributes: attributes)
      end

      def initialize_fields
        work_type_config = schema_configuration.schema_config.select { |config| config.fetch('schema') == work_type }
        return nil if work_type_config.blank?

        work_type_config.first.fetch('fields')
      end

      def core_field_count
        @core_field_count ||= core_fields.count
      end

      def core_fields
        @core_fields ||= schema_configuration.core_field_ids(work_type)
      end

      def core_field_hash
        @core_field_hash ||= Hash[loaded_core_fields.map { |item| [item.label, item] }]
      end

      def loaded_core_fields
        @loaded_core_fields ||= core_fields.map { |id| MetadataField.find(id) }
      end
  end
end
