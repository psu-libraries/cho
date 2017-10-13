# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'metadata_application_profile/fields/new', type: :view do
  let(:change_set) { MetadataApplicationProfile::FieldChangeSet.new(MetadataApplicationProfile::Field.new) }

  before do
    assign(:metadata_application_profile_field, change_set)
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
