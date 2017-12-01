# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe MetadataApplicationProfile::Field, type: :model do
  subject { model }

  let(:resource_klass) { described_class }
  let(:model) { build :metadata_application_profile_field,
                      label: 'abc123_label', field_type: 'date',
                      requirement_designation: 'recommended',
                      controlled_vocabulary: 'abc123_vocab',
                      default_value: 'abc123',
                      display_name: 'My Abc123',
                      display_transformation: 'abc123_transform',
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

  it 'can be optional' do
    model.optional!
    expect(model.requirement_designation).to eq('optional')
  end

  it 'can be text' do
    model.text!
    expect(model.field_type).to eq('text')
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
    let(:expected_metadata) { { controlled_vocabulary: 'abc123_vocab',
                                created_at: saved_model.created_at,
                                default_value: 'abc123',
                                display_name: 'My Abc123',
                                display_transformation: 'abc123_transform',
                                field_type: 'date',
                                id: saved_model.id,
                                internal_resource: 'MetadataApplicationProfile::Field',
                                label: 'abc123_label',
                                multiple: false,
                                requirement_designation: 'recommended',
                                updated_at: saved_model.updated_at,
                                validation: 'no_validation' } }

    its(:attributes) { is_expected.to eq(expected_metadata) }
  end
end
