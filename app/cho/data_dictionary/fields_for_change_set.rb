# frozen_string_literal: true

# Loops through the DataDictionary Fields and applies the changeset properties to the
#  class this is included in
module DataDictionary::FieldsForChangeSet
  extend ActiveSupport::Concern

  included do
    # @note see https://github.com/psu-libraries/cho/issues/672
    include Validation::Methods

    # There are some race conditions where the database does not yet exists, but the class is being loaded.
    #   Like when you run rake db:create
    #   This statement makes sure the rails environment can be loaded even if the database has yet to be created.
    if ActiveRecord::Base.connection.table_exists? 'orm_resources'
      DataDictionary::Field.all.each do |field|
        property field.label.parameterize.underscore.to_sym,
                 multiple: field.multiple?,
                 type: field.change_set_property_type

        validates field.label.parameterize.underscore.to_sym, with: :requirement_determination
        validates field.label.parameterize.underscore.to_sym, with: field.validation.to_sym
      end
    end

    def requirement_determination(field)
      schema_field = form_fields.select { |form_field| form_field.label == field.to_s }.first
      if schema_field.try(:required?) && blank_field?(field)
        errors.add(field, "can't be blank")
      end
    end

    def blank_field?(field)
      if field.is_a?(Valkyrie::ID)
        self[field].to_s.blank?
      else
        self[field].blank?
      end
    end
  end
end
