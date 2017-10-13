# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'metadata_application_profile/fields/show', type: :view do
  let(:metadata_application_profile_field) { build :metadata_application_profile_field,
                                                  label: 'Label',
                                                  field_type: MetadataApplicationProfile::Field::FieldTypes['numeric'],
                                                  requirement_designation: MetadataApplicationProfile::Field::RequirementDesignations['required_to_publish'],
                                                  validation: 'no_validation',
                                                  multiple: false,
                                                  controlled_vocabulary: 'Controlled Vocabulary',
                                                  default_value: 'Default Value',
                                                  display_name: 'Display Name',
                                                  display_transformation: 'Display Transformation' }

  before do
    assign(:metadata_application_profile_field, metadata_application_profile_field)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Label/)
    expect(rendered).to match(/numeric/)
    expect(rendered).to match(/required_to_publish/)
    expect(rendered).to match(/no_validation/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Controlled Vocabulary/)
    expect(rendered).to match(/Default Value/)
    expect(rendered).to match(/Display Name/)
    expect(rendered).to match(/Display Transformation/)
  end
end
