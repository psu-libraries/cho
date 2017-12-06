# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'metadata_application_profile/fields/edit', type: :view do
  let(:model) { build(:metadata_application_profile_field, field_attributes) }
  let(:metadata_application_profile_field) { MetadataApplicationProfile::FieldChangeSet.new(model) }
  let(:field_attributes) { { field_type:  MetadataApplicationProfile::Field::FieldTypes['numeric'],
                             requirement_designation: MetadataApplicationProfile::Field::RequirementDesignations['required_to_publish'],
                             validation: 'no_validation',
                             multiple: false,
                             controlled_vocabulary: 'no_vocabulary',
                             default_value: 'MyString',
                             display_name: 'MyString',
                             display_transformation: 'no_transformation' } }

  before do
    assign(:metadata_application_profile_field, metadata_application_profile_field)
  end

  it 'renders the edit metadata_field form' do
    render
    assert_select 'form[action=?][method=?]', metadata_application_profile_field_path(metadata_application_profile_field), 'post' do
      assert_select 'input[name=?]', 'metadata_application_profile_field[label]'
      assert_select 'input[name=?]', 'metadata_application_profile_field[field_type]'
      assert_select 'input[name=?]', 'metadata_application_profile_field[requirement_designation]'
      assert_select 'input[name=?]', 'metadata_application_profile_field[validation]'
      assert_select 'input[name=?]', 'metadata_application_profile_field[multiple]'
      assert_select 'input[name=?]', 'metadata_application_profile_field[controlled_vocabulary]'
      assert_select 'input[name=?]', 'metadata_application_profile_field[default_value]'
      assert_select 'input[name=?]', 'metadata_application_profile_field[display_name]'
      assert_select 'input[name=?]', 'metadata_application_profile_field[display_transformation]'
    end
  end
end
