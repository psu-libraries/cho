# frozen_string_literal: true

class Schema::MetadataCoreFields
  def self.generate(persister)
    fields = DataDictionary::Field.core_fields
    core_fields = fields.to_a.map do |field|
      schema_field = Schema::MetadataField.initialize_from_data_dictionary_field(field)
      saved_schema_field = Schema::MetadataField.where(label: schema_field.label).first
      saved_schema_field = persister.save(resource: schema_field) if saved_schema_field.blank?
      saved_schema_field
    end
    core_fields.each_with_index { |field, idx| field.order_index = Valkyrie::Types::Int.default(idx) }
  end
end
