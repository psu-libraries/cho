# Loads required fields, schemas, and work types for use with CHO
class SeedMAP
  class << self

    def load_data_dictionary
      dictionary_file = Rails.root.join('config', 'data_dictionary', "data_dictionary_#{Rails.env.downcase}.csv")
      importer = DataDictionary::CsvImporter.new(File.new(dictionary_file))
      importer.import
    end

    def schema_config
      @schema_config ||= YAML.load_file(Rails.root.join('config', 'data_dictionary', "schema_fields.yml"))[Rails.env]
    end

    def metadata_schema(type)
      core_field_ids = Schema::MetadataCoreFields.generate(Valkyrie.config.metadata_adapter.persister).map(&:id)
      fields = schema_config.select { |config| config.fetch("schema") == type }.first.fetch("fields")
      schema_fields = create_schema_fields(fields, core_field_ids)
      Schema::Metadata.new(
        label: type,
        core_fields: core_field_ids,
        fields: schema_fields.map(&:id)
      )
    end

    def create_schema_fields(fields, core_field_ids)
      fields.map do |field, attributes|
        data_dictionary_field = DataDictionary::Field.where(label: field).first
        metadata_field = Schema::MetadataField.initialize_from_data_dictionary_field(data_dictionary_field)
        metadata_field.order_index = (attributes.fetch("order_index", "1") + core_field_ids.length)
        seed_resource(metadata_field)
      end
    end

    def work_type(type)
      Work::Type.new(
        label: type,
        metadata_schema_id: Schema::Metadata.find_using(label: type).first.id,
        processing_schema: 'default',
        display_schema: 'default'
      )
    end

    def load_work_types
      schema_config.map { |config| config.fetch("schema") }.each do |type|
        seed_resource(metadata_schema(type))
        seed_resource(work_type(type)) unless type == 'Collection'
      end
    end

    def seed_resource(resource)
      return resource.class.where(label: resource.label).first if resource.class.where(label: resource.label).count > 0
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    end

    def create
      return unless ActiveRecord::Base.connection.table_exists? 'orm_resources'
      load_data_dictionary
      load_work_types
    end
  end
end

SeedMAP.create
