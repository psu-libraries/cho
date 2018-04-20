# frozen_string_literal: true

# Loops through the DataDictionary Fields and applies the changeset properties to the
#  class this is included in
module DataDictionary::FieldsForSolrDocument
  extend ActiveSupport::Concern

  included do
    # There are some race conditions where the database does not yet exists, but the class is being loaded.
    #   Like when you run rake db:create
    #   This statement makes sure the rails environment can be loaded even if the database has yet to be created.
    if ActiveRecord::Base.connection.table_exists? 'orm_resources'
      DataDictionary::Field.all.each do |field|
        next if field.field_type != 'string'

        define_method(field.label) do
          self["#{field.label}_tesim"]
        end
      end
    end
  end
end
