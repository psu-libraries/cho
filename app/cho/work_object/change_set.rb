# frozen_string_literal: true

module WorkObject
  class ChangeSet < Valkyrie::ChangeSet
    # self.fields = WorkObject::WorkObject.fields
    validates :work_type, presence: true
    property :work_type, multiple: false, required: true

    include DataDictionary::FieldsForChangeSet

    def initialize(*args)
      super(*args)
    end
  end
end
