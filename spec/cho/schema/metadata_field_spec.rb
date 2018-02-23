# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Schema::MetadataField, type: :model do
  subject { model }

  let(:resource_klass) { described_class }
  let(:model) { build :schema_metadata_field,
                      label: 'abc123_label', field_type: 'date',
                      requirement_designation: 'recommended',
                      controlled_vocabulary: 'no_vocabulary',
                      default_value: 'abc123',
                      display_name: 'My Abc123',
                      display_transformation: 'no_transformation',
                      multiple: false, validation: 'no_validation',
                      core_field: false, order_index: 0 }

  it_behaves_like 'a Valkyrie::Resource'

  it { is_expected.to respond_to(:label) }
  it { is_expected.to respond_to(:multiple) }
  it { is_expected.to respond_to(:field_type) }
  it { is_expected.to respond_to(:requirement_designation) }
  it { is_expected.to respond_to(:controlled_vocabulary) }
  it { is_expected.to respond_to(:default_value) }
  it { is_expected.to respond_to(:display_name) }
  it { is_expected.to respond_to(:display_transformation) }
  it { is_expected.to respond_to(:help_text) }
  it { is_expected.to respond_to(:index_type) }
  it { is_expected.to respond_to(:order_index) }

  context 'when saving with metadata' do
    subject { saved_model }

    let(:saved_model) { Valkyrie.config.metadata_adapter.persister.save(resource: model) }
    let(:expected_metadata) { { controlled_vocabulary: 'no_vocabulary',
                                created_at: saved_model.created_at,
                                default_value: 'abc123',
                                data_dictionary_field_id: nil,
                                display_name: 'My Abc123',
                                display_transformation: 'no_transformation',
                                field_type: 'date',
                                help_text: 'help me',
                                id: saved_model.id,
                                index_type: 'no_facet',
                                internal_resource: 'Schema::MetadataField',
                                label: 'abc123_label',
                                multiple: false,
                                requirement_designation: 'recommended',
                                updated_at: saved_model.updated_at,
                                validation: 'no_validation',
                                core_field: false,
                                order_index: 0 } }

    its(:attributes) { is_expected.to eq(expected_metadata) }
  end

  describe '#initialize_from_data_dictionary_field' do
    subject(:schema_field) { described_class.initialize_from_data_dictionary_field(data_dictionary_field) }

    let(:data_dictionary_field) { DataDictionary::Field.where(label: 'title').first }
    let(:expected_metadata) { { controlled_vocabulary: 'no_vocabulary',
                                core_field: true,
                                default_value: nil,
                                display_name: nil,
                                display_transformation: 'no_transformation',
                                field_type: 'string',
                                help_text: 'help me',
                                index_type: 'no_facet',
                                internal_resource: 'Schema::MetadataField',
                                label: 'title',
                                multiple: true,
                                requirement_designation: 'required',
                                order_index: nil,
                                validation: 'no_validation' } }

    its(:attributes) { is_expected.to include(expected_metadata) }

    it 'sets the data dictionry field id' do
      expect(schema_field.data_dictionary_field_id.to_s).to eq(data_dictionary_field.id.to_s)
    end
  end
end
