# frozen_string_literal: true

# Contains all the fields available in the entire application.
#  Does this by looping through all the fields defined in the system.
module DataDictionary::FieldsForObject
  extend ActiveSupport::Concern

  included do
    # There are some race conditions where the database does not yet exists, but the class is being loaded.
    #   Like when you run rake db:create
    #   This statement makes sure the rails environment can be loaded even if the database has yet to be created.
    if ActiveRecord::Base.connection.table_exists? 'orm_resources'
      DataDictionary::Field.all.each do |field|
        # Code reloading errors may cause this block to be run twice in
        # development - this prevents an error regarding an attribute being
        # defined twice.

        next if schema.keys.include?(field.label.parameterize.underscore.to_sym)
        attribute field.label.parameterize.underscore.to_sym, field.resource_property_type
      end
    end
  end
end
