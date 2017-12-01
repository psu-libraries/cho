# frozen_string_literal: true

# Responsible for seeding the database with any required fields for testing.
class SeedMAP
  class << self
    def create
      Valkyrie.config.metadata_adapter.persister.save(resource: title_field)
    end

    def title_field
      MetadataApplicationProfile::Field.new(
        label: 'title',
        requirement_designation: 'required_to_publish',
        field_type: 'string',
        validation: 'no_validation',
        controlled_vocabulary: 'no_vocabulary',
        multiple: true
      )
    end
  end
end

SeedMAP.create
