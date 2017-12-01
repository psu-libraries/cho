# frozen_string_literal: true

FactoryGirl.define do
  factory :metadata_application_profile_field, class: MetadataApplicationProfile::Field do
    sequence(:id)
    label 'abc123_label'
    field_type 'date'
    requirement_designation 'recommended'
    controlled_vocabulary 'no_vocabulary'
    default_value 'abc123'
    display_name 'My Abc123'
    display_transformation 'abc123_transform'
    multiple false
    validation 'no_validation'
  end

  to_create do |resource|
    change_set = MetadataApplicationProfile::FieldChangeSet.new(resource)
    Valkyrie.config.metadata_adapter.persister.save(resource: change_set)
  end
end
