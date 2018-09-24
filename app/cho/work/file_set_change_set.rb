# frozen_string_literal: true

module Work
  class FileSetChangeSet < Valkyrie::ChangeSet
    validates :member_ids, with: :validate_members!
    property :member_ids,
             multiple: true,
             required: false,
             type: Types::Strict::Array.of(Valkyrie::Types::ID)

    include DataDictionary::FieldsForChangeSet
    include WithValidMembers

    delegate :url_helpers, to: 'Rails.application.routes'

    def initialize(*args)
      super(*args)
    end
  end
end
