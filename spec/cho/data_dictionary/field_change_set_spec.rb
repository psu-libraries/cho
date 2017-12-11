# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::FieldChangeSet do
  subject(:change_set) { described_class.new(resource) }

  let(:resource) { DataDictionary::Field.new }

  before { change_set.prepopulate! }

  describe '#append_id' do
    before { change_set.append_id = Valkyrie::ID.new('test') }
    its(:append_id) { is_expected.to eq(Valkyrie::ID.new('test')) }
    its([:append_id]) { is_expected.to eq(Valkyrie::ID.new('test')) }
  end

  describe '#label' do
    it { is_expected.not_to be_multiple(:label) }
    it { is_expected.to be_required(:label) }
    its(:label) { is_expected.to be_nil }
  end

  describe '#controlled_vocabulary' do
    it { is_expected.not_to be_multiple(:controlled_vocabulary) }
    it { is_expected.not_to be_required(:controlled_vocabulary) }
    its(:controlled_vocabulary) { is_expected.to eq('no_vocabulary') }
  end

  describe '#default_value' do
    it { is_expected.not_to be_multiple(:default_value) }
    it { is_expected.not_to be_required(:default_value) }
    its(:default_value) { is_expected.to be_nil }
  end

  describe '#display_name' do
    it { is_expected.not_to be_multiple(:display_name) }
    it { is_expected.not_to be_required(:display_name) }
    its(:display_name) { is_expected.to be_nil }
  end

  describe '#display_transformation' do
    it { is_expected.not_to be_multiple(:display_transformation) }
    it { is_expected.not_to be_required(:display_transformation) }
    its(:display_transformation) { is_expected.to eq('no_transformation') }
  end

  describe '#multiple' do
    it { is_expected.not_to be_multiple(:multiple) }
    it { is_expected.not_to be_required(:multiple) }
    its(:multiple) { is_expected.to be(false) }

    context 'with coercion' do
      before { change_set.validate(params) }

      context "using 'false'" do
        let(:params) { { multiple: 'false' } }

        its(:multiple) { is_expected.to be(false) }
      end

      context 'using false' do
        let(:params) { { multiple: false } }

        its(:multiple) { is_expected.to be(false) }
      end

      context "using '0'" do
        let(:params) { { multiple: '0' } }

        its(:multiple) { is_expected.to be(false) }
      end

      context 'using 0' do
        let(:params) { { multiple: 0 } }

        its(:multiple) { is_expected.to be(false) }
      end

      context "using 'true'" do
        let(:params) { { multiple: 'true' } }

        its(:multiple) { is_expected.to be(true) }
      end

      context 'using true' do
        let(:params) { { multiple: true } }

        its(:multiple) { is_expected.to be(true) }
      end

      context "using '1'" do
        let(:params) { { multiple: '1' } }

        its(:multiple) { is_expected.to be(true) }
      end

      context 'using 1' do
        let(:params) { { multiple: 1 } }

        its(:multiple) { is_expected.to be(true) }
      end
    end
  end

  describe '#field_type' do
    it { is_expected.not_to be_multiple(:field_type) }
    it { is_expected.not_to be_required(:field_type) }
    its(:field_type) { is_expected.to eq('string') }
  end

  describe '#requirement_designation' do
    it { is_expected.not_to be_multiple(:requirement_designation) }
    it { is_expected.not_to be_required(:requirement_designation) }
    its(:requirement_designation) { is_expected.to eq('optional') }
  end

  describe '#validation' do
    it { is_expected.not_to be_multiple(:validation) }
    it { is_expected.not_to be_required(:validation) }
    its(:validation) { is_expected.to eq('no_validation') }
  end

  describe '#validate' do
    subject { change_set.errors }

    before do
      change_set.validate(params)
    end

    context 'without a label' do
      let(:params) { {} }

      its(:full_messages) { is_expected.to contain_exactly("Label can't be blank") }
    end

    context 'with an invalid validation' do
      let(:params) { { label: 'A label', validation: 'bogus' } }

      its(:full_messages) { is_expected.to contain_exactly('Validation is not included in the list') }
    end

    context 'with an invalid requirement designation' do
      let(:params) { { label: 'A label', requirement_designation: 'bogus' } }

      its(:full_messages) { is_expected.to contain_exactly('Requirement designation is not included in the list') }
    end

    context 'with an invalid field type' do
      let(:params) { { label: 'A label', field_type: 'bogus' } }

      its(:full_messages) { is_expected.to contain_exactly('Field type is not included in the list') }
    end

    context 'with a false string' do
      let(:params) { { label: 'A label', multiple: 'foo' } }

      its(:full_messages) { is_expected.to contain_exactly('Multiple is the wrong type') }
    end
  end
end
