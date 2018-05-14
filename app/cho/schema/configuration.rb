# frozen_string_literal: true

module Schema
  class Configuration
    attr_reader :schema_config, :work_types

    def initialize(schema_file_path = nil)
      schema_file_path ||= Rails.root.join('config', 'data_dictionary', 'schema_fields.yml')
      @schema_config = YAML.load_file(schema_file_path)[Rails.env]
      @work_types = schema_config.map { |config| config.fetch('schema') }
    end

    def core_field_count
      core_field_ids.length
    end

    def core_field_ids
      @core_field_ids ||= Schema::MetadataCoreFields.generate(Valkyrie.config.metadata_adapter).map(&:id)
    end

    def load_work_types
      work_types.each do |type|
        work_type_config = Schema::WorkTypeConfiguration.new(schema_configuration: self, work_type: type)
        work_type_config.generate_metadata_schema
        work_type_config.generate_work_type unless type == 'Collection'
      end
    end
  end
end
