# frozen_string_literal: true

module Work
  class SubmissionChangeSet < Valkyrie::ChangeSet
    property :optimistic_lock_token, multiple: true, required: true,
                                     type: Types::Strict::Array.of(Valkyrie::Types::OptimisticLockToken)

    validates :work_type_id, presence: true
    validates :work_type_id, with: :validate_work_type_id!
    property :work_type_id, multiple: false, required: true, type: Valkyrie::Types::ID

    validates :member_ids, with: :validate_members!
    property :member_ids,
             multiple: true,
             required: false,
             type: Types::Strict::Array.of(Valkyrie::Types::ID)

    property :batch_id, multiple: false, required: false

    # File submitted via the GUI upload
    property :file, multiple: false, required: false

    property :import_work, virtual: true, required: false, multiple: false

    property :file_set_hashes,
             virtual: true,
             multiple: true,
             required: false,
             default: [],
             type: Types::Strict::Array

    include DataDictionary::FieldsForChangeSet
    include WithValidMembers
    include WithFormFields
    include Work::WithErrorMessages

    delegate :url_helpers, to: 'Rails.application.routes'

    def initialize(*args)
      super(*args)
    end

    def validate_work_type_id!(field)
      return if work_type_id.blank?
      errors.add(field, 'can not be changed') if id.present? && work_type_id.id != model.work_type_id.id
      errors.add(field, "#{work_type_id} does not exist") if work_type.blank?
    end

    # @param [ActionView::Helpers::FormBuilder] form
    # @return [Array<Schema::InputField>]
    def input_fields(form)
      form_fields.map { |field| Schema::InputField.new(form: form, metadata_field: field) }
    end

    def work_type
      return if work_type_id.nil?

      @work_type ||= Work::Type.find(work_type_id)
    end

    def submit_text
      if model.persisted?
        I18n.t('cho.work.edit.submit')
      else
        I18n.t('cho.work.new.submit')
      end
    end

    def form_path
      if model.persisted?
        url_helpers.work_path(model)
      else
        url_helpers.works_path
      end
    end

    private

      def metadata_schema
        @metadata_schema ||= work_type.present? ? work_type.metadata_schema : Schema::None.new
      end
  end
end
