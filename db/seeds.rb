# Loads required fields, schemas, and work types for use with CHO

# @todo move this to a CSV-based process
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

# @todo move this to a CSV-based process
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

# @todo move this to a CSV-based process
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

def work_type(type)
  Work::Type.new(
    label: type,
    metadata_schema_id: Schema::Metadata.find_using(label: 'default').first.id,
    processing_schema: 'default',
    display_schema: 'default'
  )
end

def load_work_types
  ["Generic", "Document", "Still Image", "Map", "Moving Image", "Audio"].each do |type|
    seed_resource(work_type(type))
  end
end

def seed_resource(resource)
  return if resource.class.where(label: resource.label).count > 0
  Valkyrie.config.metadata_adapter.persister.save(resource: resource)
end

seed_resource(default_metadata_schema)
seed_resource(title_field)
seed_resource(subtitle_field)
seed_resource(description_field)
load_work_types
