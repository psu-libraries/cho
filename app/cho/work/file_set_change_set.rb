# frozen_string_literal: true

module Work
  class FileSetChangeSet < Valkyrie::ChangeSet
    validates :member_ids, with: :validate_members!
    property :member_ids,
             multiple: true,
             required: false,
             type: Types::Strict::Array.of(Valkyrie::Types::ID)

    property :optimistic_lock_token, multiple: true, required: true,
                                     type: Types::Strict::Array.of(Valkyrie::Types::OptimisticLockToken)

    include DataDictionary::FieldsForChangeSet
    include WithValidMembers
    include WithFormFields
    include Work::WithErrorMessages

    delegate :url_helpers, to: 'Rails.application.routes'

    def initialize(*args)
      super(*args)
    end

    # @param [ActionView::Helpers::FormBuilder] form
    # @return [Array<Schema::InputField>]
    def input_fields(form)
      form_fields.map { |field| Schema::InputField.new(form: form, metadata_field: field) }
    end

    private

      def metadata_schema
        @metadata_schema ||= Schema::Metadata.find_using(label: 'FileSet').first
      end
  end
end
