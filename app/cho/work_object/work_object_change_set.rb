# frozen_string_literal: true

class WorkObjectChangeSet < Valkyrie::ChangeSet
  # self.fields = WorkObject.fields
  validates :work_type, presence: true
  property :work_type, multiple: false, required: true

  include DataDictionary::FieldsForChangeSet
end
