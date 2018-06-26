# frozen_string_literal: true

class Schema::MetadataCoreFields
  def self.generate(adapter, work_type:)
    fields = DataDictionary::Field.core_fields
    fields.sort_by(&:created_at).each_with_index.map do |field, idx|
      schema_field = Schema::MetadataField.initialize_from_data_dictionary_field(field, work_type: work_type)
      schema_field.order_index = idx
      ChangeSetPersister.new(
        metadata_adapter: adapter, storage_adapter: nil
      ).update_or_create(schema_field, unique_attributes: [:label, :work_type])
    end
  end
end
