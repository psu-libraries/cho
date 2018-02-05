# frozen_string_literal: true

# Responsible for seeding the database with any required fields for testing.
class SeedMAP
  class << self
    # @note Don't create any fields if the database doesn't exist yet. This avoids some race conditions
    #       and makes sure the rails environment can be loaded.
    def create
      return unless ActiveRecord::Base.connection.table_exists? 'orm_resources'
      Valkyrie.config.metadata_adapter.persister.save(resource: title_field)
      Valkyrie.config.metadata_adapter.persister.save(resource: subtitle_field)
      Valkyrie.config.metadata_adapter.persister.save(resource: description_field)
      Valkyrie.config.metadata_adapter.persister.save(resource: default_metadata_schema)
      Valkyrie.config.metadata_adapter.persister.save(resource: generic_work_type)
      Valkyrie.config.metadata_adapter.persister.save(resource: document_work_type)
    end

    def title_field
      DataDictionary::Field.new(
        label: 'title',
        requirement_designation: 'required_to_publish',
        field_type: 'string',
        validation: 'no_validation',
        controlled_vocabulary: 'no_vocabulary',
        display_transformation: 'no_transformation',
        multiple: true,
        help_text: 'help me',
        index_type: 'no_facet'
      )
    end

    def subtitle_field
      DataDictionary::Field.new(
        label: 'subtitle',
        requirement_designation: 'optional',
        field_type: 'string',
        validation: 'no_validation',
        controlled_vocabulary: 'no_vocabulary',
        display_transformation: 'no_transformation',
        multiple: true,
        help_text: 'help me',
        index_type: 'no_facet'
      )
    end

    def description_field
      DataDictionary::Field.new(
        label: 'description',
        requirement_designation: 'optional',
        field_type: 'string',
        validation: 'no_validation',
        controlled_vocabulary: 'no_vocabulary',
        display_transformation: 'no_transformation',
        multiple: true,
        help_text: 'help me',
        index_type: 'no_facet'
      )
    end

    def default_metadata_schema
      Schema::Metadata.new(
        label: 'default',
        core_fields: DataDictionary::Field.all.map(&:id)
      )
    end

    def generic_work_type
      Work::Type.new(
        label: 'Generic',
        metadata_schema_id: Schema::Metadata.find_using(label: 'default').first.id,
        processing_schema: 'default',
        display_schema: 'default'
      )
    end

    def document_work_type
      Work::Type.new(
        label: 'Document',
        metadata_schema_id: Schema::Metadata.find_using(label: 'default').first.id,
        processing_schema: 'default',
        display_schema: 'default'
      )
    end
  end
end

SeedMAP.create
