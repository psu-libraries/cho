# frozen_string_literal: true

class Schema::MetadataCoreFields
  def self.generate(adapter)
    fields = DataDictionary::Field.core_fields
    fields.to_a.each_with_index.map do |field, idx|
      schema_field = Schema::MetadataField.initialize_from_data_dictionary_field(field)
      schema_field.order_index = idx
      ChangeSetPersister.new(
        metadata_adapter: adapter, storage_adapter: nil
      ).update_or_create(schema_field, unique_attribute: :label)
    end
  end
end
