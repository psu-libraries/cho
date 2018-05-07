# frozen_string_literal: true

module Work
  class SubmissionChangeSet < Valkyrie::ChangeSet
    validates :work_type_id, presence: true
    validates :work_type_id, with: :validate_work_type_id!
    property :work_type_id, multiple: false, required: true, type: Valkyrie::Types::ID
    property :file, multiple: false, required: false
    validates :member_of_collection_ids, with: :validate_members!
    validates :member_of_collection_ids, presence: true
    property :member_of_collection_ids,
             multiple: true,
             required: false,
             type: Types::Strict::Array.of(Valkyrie::Types::ID)

    include DataDictionary::FieldsForChangeSet
    delegate :url_helpers, to: 'Rails.application.routes'

    def initialize(*args)
      super(*args)
    end

    # @note modifies the elements in the field to contain resources that exist. Any non-existing
    #   resources are added as errors to the change set.
    def validate_members!(field)
      members = self[field].map { |id| Member.new(id) }
      members.each do |member|
        errors.add(field, "#{member.id} does not exist") unless member.exists?
      end
    end

    def validate_work_type_id!(field)
      return if work_type_id.blank?
      errors.add(field, "#{work_type_id} does not exist") if work_type.blank?
    end

    def form_fields
      return @form_fields if @form_fields.present?
      field_ids = metadata_schema.core_fields + metadata_schema.fields
      unordered_fields = field_ids.map { |id| Schema::MetadataField.find(id) }
      @form_fields = unordered_fields.sort_by(&:order_index)
    end

    # @param [ActionView::Helpers::FormBuilder] form
    # @return [Array<Schema::InputField>]
    def input_fields(form)
      form_fields.map { |field| Schema::InputField.new(form: form, metadata_field: field) }
    end

    def work_type
      # TODO - This code can be removed when we upgrade to Valkyrie 1.0 as it now takes either a string or and ID
      id = if work_type_id.is_a?(Valkyrie::ID)
             work_type_id
           else
             Valkyrie::ID.new(work_type_id)
           end
      @work_type ||= Work::Type.find(id)
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

    class Member
      attr_reader :id

      def initialize(id)
        @id = Valkyrie::ID.new(id)
      end

      def exists?
        Valkyrie.config.metadata_adapter.query_service.find_by(id: id)
        true
      rescue Valkyrie::Persistence::ObjectNotFoundError
        false
      end
    end

    private

      def metadata_schema
        @metadata_schema ||= work_type.metadata_schema
      end
  end
end
