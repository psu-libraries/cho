# frozen_string_literal: true

class CollectionChangeSet < Valkyrie::ChangeSet
  property :title, multiple: false, required: true
  validates :title, presence: true

  property :collection_type, multiple: false, required: true
  validates :collection_type, inclusion: { in: ::Collection::Types }
  validates :collection_type, presence: true

  property :description, multiple: false, required: false
end
