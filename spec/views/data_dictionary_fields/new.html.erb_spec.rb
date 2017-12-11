# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'data_dictionary/fields/new', type: :view do
  let(:change_set) { DataDictionary::FieldChangeSet.new(DataDictionary::Field.new) }

  before do
    assign(:data_dictionary_field, change_set)
  end

  it 'renders new dictionary_field form' do
    render

    assert_select 'form[action=?][method=?]', data_dictionary_fields_path, 'post' do
      assert_select 'input[name=?]', 'data_dictionary_field[label]'

      assert_select 'input[name=?]', 'data_dictionary_field[field_type]'

      assert_select 'input[name=?]', 'data_dictionary_field[requirement_designation]'

      assert_select 'input[name=?]', 'data_dictionary_field[validation]'

      assert_select 'input[name=?]', 'data_dictionary_field[multiple]'

      assert_select 'input[name=?]', 'data_dictionary_field[controlled_vocabulary]'

      assert_select 'input[name=?]', 'data_dictionary_field[default_value]'

      assert_select 'input[name=?]', 'data_dictionary_field[display_name]'

      assert_select 'input[name=?]', 'data_dictionary_field[display_transformation]'
    end
  end
end
