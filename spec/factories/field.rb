# frozen_string_literal: true

FactoryGirl.define do
  factory :data_dictionary_field, class: DataDictionary::Field do
    sequence(:id)
    label 'abc123_label'
    field_type 'date'
    requirement_designation 'recommended'
    controlled_vocabulary 'no_vocabulary'
    default_value 'abc123'
    display_name 'My Abc123'
    display_transformation 'no_transformation'
    multiple false
    validation 'no_validation'

    to_create do |resource|
      Valkyrie.config.metadata_adapter.persister.save(resource: resource)
    end
  end
end
