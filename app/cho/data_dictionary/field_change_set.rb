# frozen_string_literal: true

module DataDictionary
  class FieldChangeSet < Valkyrie::ChangeSet
    include DataDictionary::FieldChangeSetProperties

    validates :label, presence: true, 'data_dictionary/unique': true
  end
end
