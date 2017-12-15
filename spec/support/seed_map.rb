# frozen_string_literal: true

# Responsible for seeding the database with any required fields for testing.
class SeedMAP
  class << self
    def create
      # There are some race conditions where the database does not yet exists, but the class is being loaded.
      #   Like when you run rake db:create
      #   This statement makes sure the rails environment can be loaded even if the database has yet to be created.
      if ActiveRecord::Base.connection.table_exists? 'orm_resources'
        Valkyrie.config.metadata_adapter.persister.save(resource: title_field)
      end
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
  end
end

SeedMAP.create
