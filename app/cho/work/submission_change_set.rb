# frozen_string_literal: true

module Work
  class SubmissionChangeSet < Valkyrie::ChangeSet
    validates :work_type, presence: true
    property :work_type, multiple: false, required: true
    property :file, multiple: false, required: false

    include DataDictionary::FieldsForChangeSet

    def initialize(*args)
      super(*args)
    end
  end
end
