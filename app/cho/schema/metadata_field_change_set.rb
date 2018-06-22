# frozen_string_literal: true

module Schema
  class MetadataFieldChangeSet < Valkyrie::ChangeSet
    include DataDictionary::FieldChangeSetProperties

    validates :label, presence: true, 'schema/unique': true

    property :order_index, multiple: false, required: true
    validates :order_index, presence: true
    property :data_dictionary_field_id, multiple: false, required: true
    validates :data_dictionary_field_id, presence: true
    property :work_type, multiple: false, required: true
    validates :work_type, presence: true
  end
end
