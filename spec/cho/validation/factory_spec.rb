# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::Factory, type: :model do
  subject { described_class.validators = validator_list }

  before (:all) do
    class MyValidator < Validation::Base
    end
    class OtherValidator < Validation::Base
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyValidator')
    ActiveSupport::Dependencies.remove_constant('OtherValidator')
  end

  let(:validator_list) { {} }

  it { within_block_is_expected.not_to raise_exception }

  context 'valid validator' do
    let(:validator_list) { { my_validator: MyValidator.new } }

    it { within_block_is_expected.not_to raise_exception }

    describe '#validator_names' do
      subject(:names) { described_class.validator_names }

      it do
        expect(names).to contain_exactly(
          'creator',
          'my_validator',
          'no_validation',
          'resource_exists',
          'unique',
          'edtf_date',
          'character_encoding'
        )
      end
    end
  end

  context 'bad validator' do
    let(:validator_list) { { my_validator: Date.new } }

    it { within_block_is_expected.to raise_error 'Invalid validator(s) in validation list: my_validator' }
  end

  context 'with multiple validators' do
    let(:my_validator) { MyValidator.new }
    let(:validator_list) { { my_validator: my_validator, other_validator: OtherValidator.new } }

    before do
      described_class.validators = validator_list
    end

    it { within_block_is_expected.not_to raise_exception }

    it 'allows lookup' do
      expect(described_class.lookup(:my_validator)).to eq(my_validator)
    end

    it 'does not lookup invalid names' do
      expect(described_class.lookup(:blarg)).to be_nil
    end

    describe '#validator_names' do
      subject(:names) { described_class.validator_names }

      it do
        expect(names).to contain_exactly(
          'creator',
          'my_validator',
          'other_validator',
          'no_validation',
          'resource_exists',
          'edtf_date',
          'unique',
          'character_encoding'
        )
      end
    end
  end
end
