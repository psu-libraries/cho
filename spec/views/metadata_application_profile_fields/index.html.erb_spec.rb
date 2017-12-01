# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'metadata_application_profile/fields/index', type: :view do
  let(:metadata_field1) { build(:metadata_application_profile_field, label: 'Label') }
  let(:metadata_field2) { build(:metadata_application_profile_field, label: 'Label Two') }

  before do
    assign(:metadata_application_profile_fields, [metadata_field1, metadata_field2])
  end

  it 'renders a list of metadata_application_profile_fields' do
    render
    assert_select 'tr>td', text: 'Label', count: 1
    assert_select 'tr>td', text: 'Label Two', count: 1
    assert_select 'tr>td', text: 'date', count: 2
    assert_select 'tr>td', text: 'recommended', count: 2
    assert_select 'tr>td', text: 'no_validation', count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: 'no_vocabulary', count: 2
    assert_select 'tr>td', text: 'abc123'.to_s, count: 2
    assert_select 'tr>td', text: 'My Abc123'.to_s, count: 2
    assert_select 'tr>td', text: 'abc123_transform'.to_s, count: 2
  end
end
