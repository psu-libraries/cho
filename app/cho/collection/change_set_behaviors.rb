# frozen_string_literal: true

module Collection::ChangeSetBehaviors
  extend ActiveSupport::Concern
  include DataDictionary::FieldsForChangeSet
  include Work::WithErrorMessages

  included do
    property :workflow, multiple: false, required: true
    validates :workflow, inclusion: { in: ::Collection::CommonFields::WORKFLOW }
    validates :workflow, presence: true

    property :visibility, multiple: false, required: true
    validates :visibility, inclusion: { in: ::Collection::CommonFields::VISIBILITY }
    validates :visibility, presence: true
  end

  # @return [Array<Schema::MetadataField>]
  def form_fields
    @form_fields ||= ordered_form_fields
  end

  # @param [ActionView::Helpers::FormBuilder] form
  # @return [Array<Schema::InputField>]
  def input_fields(form)
    form_fields.map { |field| Schema::InputField.new(form: form, metadata_field: field) }
  end

  private

    def ordered_form_fields
      metadata_schema = Schema::Metadata.find_using(label: 'Collection').first
      field_ids = metadata_schema.core_fields + metadata_schema.fields
      unordered_fields = field_ids.map { |id| Schema::MetadataField.find(id) }
      unordered_fields.sort_by(&:order_index)
    end
end
