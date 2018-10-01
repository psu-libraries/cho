# frozen_string_literal: true

module Work::WithFormFields
  def form_fields
    return @form_fields if @form_fields.present?
    field_ids = metadata_schema.core_fields + metadata_schema.fields
    unordered_fields = field_ids.map { |id| Schema::MetadataField.find(id) }
    @form_fields = unordered_fields.sort_by(&:order_index)
  end
end
