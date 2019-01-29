# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'data_dictionary/fields/edit', type: :view do
  let(:model) { build(:data_dictionary_field, field_attributes) }
  let(:data_dictionary_field) { DataDictionary::FieldChangeSet.new(model) }

  let(:field_attributes) do
    {
      id: Valkyrie::ID.new('1234'),
      field_type: DataDictionary::Field::FieldTypes['numeric'],
      requirement_designation: DataDictionary::Field::RequirementDesignations['required_to_publish'],
      validation: 'no_validation',
      multiple: false,
      controlled_vocabulary: 'no_vocabulary',
      default_value: 'MyString',
      display_name: 'MyString',
      display_transformation: 'no_transformation'
    }
  end

  before do
    assign(:data_dictionary_field, data_dictionary_field)
  end

  it 'renders the edit dictionary_field form' do
    render
    assert_select 'form[action=?][method=?]', data_dictionary_field_path(data_dictionary_field), 'post' do
      assert_select 'input[name=?]', 'data_dictionary_field[label]'
      assert_select 'input[name=?]', 'data_dictionary_field[field_type]'
      assert_select 'input[name=?]', 'data_dictionary_field[requirement_designation]'
      assert_select 'input[name=?]', 'data_dictionary_field[validation]'
      assert_select 'input[name=?]', 'data_dictionary_field[multiple]'
      assert_select 'input[name=?]', 'data_dictionary_field[controlled_vocabulary]'
      assert_select 'input[name=?]', 'data_dictionary_field[default_value]'
      assert_select 'input[name=?]', 'data_dictionary_field[display_name]'
      assert_select 'input[name=?]', 'data_dictionary_field[display_transformation]'
      assert_select 'input[name=?]', 'data_dictionary_field[help_text]'
      assert_select 'input[name=?]', 'data_dictionary_field[index_type]'
    end
  end
end
