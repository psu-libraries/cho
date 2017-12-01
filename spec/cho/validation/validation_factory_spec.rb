# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::ValidatorFactory, type: :model do
  before (:all) do
    class MyValidator < Validation::Validator
    end
    class OtherValidator < Validation::Validator
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyValidator')
    ActiveSupport::Dependencies.remove_constant('OtherValidator')
  end

  subject(:factory) { described_class.new(validator_list) }

  let(:validator_list) { {} }

  it { within_block_is_expected.not_to raise_exception }

  context 'valid validator' do
    let(:validator_list) { { my_validator: MyValidator.new } }

    it { within_block_is_expected.not_to raise_exception }

    describe '#validators' do
      subject { factory.validators }

      it { is_expected.to contain_exactly('my_validator') }
    end
  end

  context 'bad validator' do
    let(:validator_list) { { my_validator: Date.new } }

    it { within_block_is_expected.to raise_error 'Invalid validator(s) in validation list: my_validator' }
  end

  context 'with multiple validators' do
    let(:my_validator) { MyValidator.new }
    let(:validator_list) { { my_validator: my_validator, other_validator: OtherValidator.new } }

    it { within_block_is_expected.not_to raise_exception }

    it 'allows lookup' do
      expect(factory.lookup(:my_validator)).to eq(my_validator)
    end

    it 'does not lookup invalid names' do
      expect(factory.lookup(:blarg)).to be_nil
    end

    describe '#validators' do
      subject { factory.validators }

      it { is_expected.to contain_exactly('my_validator', 'other_validator') }
    end
  end
end
