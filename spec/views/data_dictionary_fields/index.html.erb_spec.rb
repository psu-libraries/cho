# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'data_dictionary/fields/index', type: :view do
  let(:dictionary_field1) { build(:data_dictionary_field, label: 'Label', core_field: true) }
  let(:dictionary_field2) { build(:data_dictionary_field, label: 'Label Two') }

  before do
    assign(:data_dictionary_fields, [dictionary_field1, dictionary_field2])
  end

  it 'renders a list of data_dictionary_fields' do
    render
    assert_select 'tr>td', text: 'Label', count: 1
    assert_select 'tr>td', text: 'Label Two', count: 1
    assert_select 'tr>td', text: 'date', count: 2
    assert_select 'tr>td', text: 'recommended', count: 2
    assert_select 'tr>td', text: 'no_validation', count: 2
    assert_select 'tr>td', text: false.to_s, count: 3
    assert_select 'tr>td', text: true.to_s, count: 1
    assert_select 'tr>td', text: 'no_vocabulary', count: 2
    assert_select 'tr>td', text: 'abc123'.to_s, count: 2
    assert_select 'tr>td', text: 'My Abc123'.to_s, count: 2
    assert_select 'tr>td', text: 'no_transformation'.to_s, count: 2
  end
end
