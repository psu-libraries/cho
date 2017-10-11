# frozen_string_literal: true

FactoryGirl.define do
  factory :metadata_application_profile_field do
    sequence(:id)
    label 'abc123_label'
    field_type 'date'
    requirement_designation 'recommended'
    controlled_vocabulary 'abc123_vocab'
    default_value 'abc123'
    display_name 'My Abc123'
    display_transformation 'abc123_transform'
    multiple false
    validation 'no_validation'
  end
end
