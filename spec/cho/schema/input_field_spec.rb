# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Schema::InputField, type: :model do
  subject { model }

  let(:model) { described_class.new(form: form, metadata_field: metadata_field) }
  let(:metadata_field) do
    build :schema_metadata_field,
      label: 'abc123_label',
      field_type: 'date',
      requirement_designation: 'recommended',
      controlled_vocabulary: 'no_vocabulary',
      default_value: 'abc123',
      display_name: 'My Abc123',
      display_transformation: 'no_transformation',
      multiple: false, validation: 'no_validation',
      core_field: false, order_index: 0,
      work_type: 'something'
  end

  let(:form) { instance_double ActionView::Helpers::FormBuilder }

  it { is_expected.to respond_to(:text?) }
  it { is_expected.to respond_to(:required?) }
  it { is_expected.to respond_to(:valkyrie_id?) }
  it { is_expected.to respond_to(:label) }

  describe '#display_label' do
    subject { model.display_label }

    context 'when there is a display label' do
      it { is_expected.to eq('My Abc123') }
    end

    context 'when there is no display name' do
      before { metadata_field.display_name = nil }

      it { is_expected.to eq('Abc123 Label') }
    end
  end

  describe '#partial' do
    subject { model.partial }

    before { metadata_field.field_type = type }

    context 'with the default string type' do
      let(:type) { 'string' }

      it { is_expected.to eq('string') }
    end

    context 'text field type' do
      let(:type) { 'text' }

      it { is_expected.to eq('text') }
    end

    context 'numeric field type' do
      let(:type) { 'numeric' }

      it { is_expected.to eq('string') }
    end

    context 'date field type' do
      let(:type) { 'date' }

      it { is_expected.to eq('string') }
    end

    context 'valkyrie_id field type' do
      let(:type) { 'valkyrie_id' }

      it { is_expected.to eq('valkyrie_id') }
    end

    context 'alternate_id field type' do
      let(:type) { 'alternate_id' }

      it { is_expected.to eq('string') }
    end
  end

  describe '#options' do
    subject { model.options }

    context 'when the field is not required' do
      it { is_expected.to include("aria-required": false, required: false) }
    end

    context 'when the field is required' do
      before { metadata_field.requirement_designation = 'required' }

      it { is_expected.to include("aria-required": true, required: true) }
    end
  end

  describe '#datalist' do
    subject { model.datalist }

    before { metadata_field.field_type = type }

    context 'with the default string type' do
      let(:type) { 'string' }

      it { is_expected.to be_empty }
    end

    context 'text field type' do
      let(:type) { 'text' }

      it { is_expected.to be_empty }
    end

    context 'numeric field type' do
      let(:type) { 'numeric' }

      it { is_expected.to be_empty }
    end

    context 'date field type' do
      let(:type) { 'date' }

      it { is_expected.to be_empty }
    end

    context 'valkyrie_id field type' do
      let(:type) { 'valkyrie_id' }

      it { is_expected.to eq(ControlledVocabulary::Collections.list) }
    end

    context 'alternate_id field type' do
      let(:type) { 'alternate_id' }

      it { is_expected.to be_empty }
    end
  end

  describe '#value' do
    let(:resource) { instance_double('Resource', abc123_label: ['value']) }

    before { allow(form).to receive(:object).and_return(resource) }

    its(:value) { is_expected.to eq('value') }
  end
end
