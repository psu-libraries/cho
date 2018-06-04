# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'data_dictionary/fields/show', type: :view do
  let(:data_dictionary_field) do
    build :data_dictionary_field,
      label: 'Label',
      field_type: DataDictionary::Field::FieldTypes['numeric'],
      requirement_designation: DataDictionary::Field::RequirementDesignations['required_to_publish'],
      core_field: true,
      validation: 'no_validation',
      multiple: false,
      controlled_vocabulary: 'no_vocabulary',
      default_value: 'Default Value',
      display_name: 'Display Name',
      display_transformation: 'no_transformation',
      help_text: 'helping me',
      index_type: 'facet'
  end

  before do
    assign(:data_dictionary_field, data_dictionary_field)
  end

  it 'renders attributes in <dd>' do
    render
    expect(rendered).to match(/<dd>Label<\/dd>/)
    expect(rendered).to match(/<dd>numeric<\/dd>/)
    expect(rendered).to match(/<dd>required_to_publish<\/dd>/)
    expect(rendered).to match(/<dt>Core Field<\/dt>\n    <dd>true<\/dd>/)
    expect(rendered).to match(/<dd>no_validation<\/dd>/)
    expect(rendered).to match(/<dt>Multiple<\/dt>\n    <dd>false<\/dd>/)
    expect(rendered).to match(/<dd>no_vocabulary<\/dd>/)
    expect(rendered).to match(/<dd>Default Value<\/dd>/)
    expect(rendered).to match(/<dd>Display Name<\/dd>/)
    expect(rendered).to match(/<dd>no_transformation<\/dd>/)
    expect(rendered).to match(/<dd>helping me<\/dd>/)
    expect(rendered).to match(/<dd>facet<\/dd>/)
  end
end
