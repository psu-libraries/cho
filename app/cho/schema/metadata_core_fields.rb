# frozen_string_literal: true

class Schema::MetadataCoreFields
  def self.generate(persister)
    fields = DataDictionary::Field.core_fields
    fields.to_a.each_with_index.map do |field, idx|
      schema_field = Schema::MetadataField.initialize_from_data_dictionary_field(field)
      schema_field.order_index = idx
      saved_schema_field = Schema::MetadataField.where(label: schema_field.label).first
      saved_schema_field = persister.save(resource: schema_field) if saved_schema_field.blank?
      saved_schema_field
    end
  end
end
