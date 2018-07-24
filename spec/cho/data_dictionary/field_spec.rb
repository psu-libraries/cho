# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe DataDictionary::Field, type: :model do
  subject { model }

  let(:resource_klass) { described_class }
  let(:model) { build :data_dictionary_field,
                      label: 'abc123_label', field_type: 'date',
                      requirement_designation: 'recommended',
                      controlled_vocabulary: 'no_vocabulary',
                      default_value: 'abc123',
                      display_name: 'My Abc123',
                      display_transformation: 'no_transformation',
                      multiple: false, validation: 'no_validation' }

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
  it { is_expected.to respond_to(:core_field) }

  it 'can be optional' do
    model.optional!
    expect(model.requirement_designation).to eq('optional')
  end

  it 'can be text' do
    model.text!
    expect(model.field_type).to eq('text')
  end

  it 'can be facet' do
    model.facet!
    expect(model.index_type).to eq('facet')
  end

  # this test assumes the data dictionary has been seeded with 3 core fields
  describe '#core' do
    subject { described_class.core_fields.to_a.map(&:label) }

    it { is_expected.to eq(['title', 'subtitle', 'description', 'identifier']) }
  end

  describe '#multiple' do
    context 'when not set to a boolean' do
      it 'raises an error' do
        expect { model.multiple = 'foo' }.to raise_error(Dry::Types::ConstraintError)
      end
    end
  end

  describe '#multiple?' do
    context 'when set to true' do
      before { model.multiple = true }
      it { is_expected.to be_multiple }
    end

    context 'when set to false' do
      before { model.multiple = false }
      it { is_expected.not_to be_multiple }
    end

    context 'when set to nil' do
      it { is_expected.not_to be_multiple }
    end
  end

  context 'when saving with metadata' do
    subject { saved_model }

    let(:saved_model) { Valkyrie.config.metadata_adapter.persister.save(resource: model) }
    let(:expected_metadata) { { controlled_vocabulary: 'no_vocabulary',
                                created_at: saved_model.created_at,
                                default_value: 'abc123',
                                display_name: 'My Abc123',
                                display_transformation: 'no_transformation',
                                field_type: 'date',
                                help_text: 'help me',
                                id: saved_model.id,
                                index_type: 'no_facet',
                                internal_resource: 'DataDictionary::Field',
                                label: 'abc123_label',
                                multiple: false,
                                new_record: false,
                                requirement_designation: 'recommended',
                                updated_at: saved_model.updated_at,
                                validation: 'no_validation',
                                core_field: false } }

    its(:attributes) { is_expected.to eq(expected_metadata) }
  end
end
