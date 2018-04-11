# frozen_string_literal: true

module Work
  class SubmissionChangeSet < Valkyrie::ChangeSet
    validates :work_type, presence: true
    property :work_type, multiple: false, required: true
    property :file, multiple: false, required: false
    validates :member_of_collection_ids, with: :validate_members!
    property :member_of_collection_ids,
             multiple: true,
             required: false,
             type: Types::Strict::Array.member(Valkyrie::Types::ID)

    include DataDictionary::FieldsForChangeSet
    alias :work_type_id :work_type
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

    def form_fields
      return @form_fields if @form_fields.present?
      field_ids = metadata_schema.core_fields + metadata_schema.fields
      unordered_fields = field_ids.map { |id| Schema::MetadataField.find(id) }
      @form_fields = unordered_fields.sort_by(&:order_index)
    end

    def work_type_model
      @work_type ||= Work::Type.find(Valkyrie::ID.new(work_type_id))
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
        @metadata_schema ||= work_type_model.metadata_schema
      end
  end
end
