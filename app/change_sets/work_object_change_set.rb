# frozen_string_literal: true

class WorkObjectChangeSet < Valkyrie::ChangeSet
  self.fields = WorkObject.fields
  validates :work_type, :title, presence: true

  property :title, multiple: true, required: true
  property :work_type, multiple: false, required: true
end
