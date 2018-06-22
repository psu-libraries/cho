# frozen_string_literal: true

module Schema
  class Configuration
    attr_reader :schemas, :schema_config

    Struct.new('Schema', :type, :work_type?)

    def initialize(schema_file_path = nil)
      schema_file_path ||= Rails.root.join('config', 'data_dictionary', 'schema_fields.yml')
      @schema_config = YAML.load_file(schema_file_path)[Rails.env]
      @schemas = schema_config.map do |config|
        Struct::Schema.new(config.fetch('schema'), (config.fetch('work_type', 'true') == 'true'))
      end
    end

    def core_field_count
      core_field_ids.length
    end

    def core_field_ids
      @core_field_ids ||= Schema::MetadataCoreFields.generate(Valkyrie.config.metadata_adapter).map(&:id)
    end

    def load_work_types
      schemas.each do |schema|
        work_type_config = Schema::WorkTypeConfiguration.new(schema_configuration: self, work_type: schema.type)
        work_type_config.generate_metadata_schema
        work_type_config.generate_work_type if schema.work_type?
      end
    end
  end
end
