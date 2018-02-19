# Loads required fields, schemas, and work types for use with CHO
class SeedMAP
  class << self

    def load_data_dictionary
      importer = DataDictionary::CsvImporter.new(File.new('data_dictionary.csv'))
      importer.import
    end

    def core_field_ids
      Schema::MetadataCoreFields.generate(Valkyrie.config.metadata_adapter.persister).map(&:id)
    end

    def metadata_schema(type)
      data_dictionary_field = DataDictionary::Field.where(label: "#{type.parameterize(separator: '_')}_field").first
      metadata_field = Schema::MetadataField.initialize_from_data_dictionary_field(data_dictionary_field)
      metadata_field.order_index = 3
      metadata_field = seed_resource(metadata_field)
      Schema::Metadata.new(
        label: type, core_fields: core_field_ids,
                fields: [metadata_field.id]
      )
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
      ["Generic", "Document", "Still Image", "Map", "Moving Image", "Audio"].each do |type|
        seed_resource(metadata_schema(type))
        seed_resource(work_type(type))
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
