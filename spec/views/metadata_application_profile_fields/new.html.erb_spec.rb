# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'metadata_application_profile/fields/new', type: :view do
  let(:metadata_application_profile_field) { build :metadata_application_profile_field,
                                                   label: 'MyString',
                                                   field_type: MetadataApplicationProfile::Field.field_types[:numeric],
                                                   requirement_designation: MetadataApplicationProfile::Field.requirement_designations[:required_to_publish],
                                                   validation: 'no_validation',
                                                   multiple: false,
                                                   controlled_vocabulary: 'MyString',
                                                   default_value: 'MyString',
                                                   display_name: 'MyString',
                                                   display_transformation: 'MyString'}

  before do
    assign(:metadata_application_profile_field, metadata_application_profile_field)
  end

  it 'renders new metadata_field form' do
    render

    assert_select 'form[action=?][method=?]', metadata_application_profile_fields_path, 'post' do
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
