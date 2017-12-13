# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'data_dictionary/fields/show', type: :view do
  let(:data_dictionary_field) { build :data_dictionary_field,
                                                  label: 'Label',
                                                  field_type: DataDictionary::Field::FieldTypes['numeric'],
                                                  requirement_designation: DataDictionary::Field::RequirementDesignations['required_to_publish'],
                                                  validation: 'no_validation',
                                                  multiple: false,
                                                  controlled_vocabulary: 'no_vocabulary',
                                                  default_value: 'Default Value',
                                                  display_name: 'Display Name',
                                                  display_transformation: 'no_transformation',
                                                  help_text: 'helping me',
                                                  index_type: 'facet'}

  before do
    assign(:data_dictionary_field, data_dictionary_field)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Label/)
    expect(rendered).to match(/numeric/)
    expect(rendered).to match(/required_to_publish/)
    expect(rendered).to match(/no_validation/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/no_vocabulary/)
    expect(rendered).to match(/Default Value/)
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/no_transformation/)
    expect(rendered).to match(/helping me/)
    expect(rendered).to match(/facet/)
  end
end
