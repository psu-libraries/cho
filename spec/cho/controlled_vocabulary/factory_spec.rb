# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::Factory, type: :model do
  before (:all) do
    class MyVocab < ControlledVocabulary::Base
    end
    class OtherVocab < ControlledVocabulary::Base
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyVocab')
    ActiveSupport::Dependencies.remove_constant('OtherVocab')
  end

  subject(:factory) { described_class.new }

  it { within_block_is_expected.not_to raise_exception }

  describe '#vocabularies=' do
    subject { described_class.vocabularies = vocabularies }

    let(:vocabularies) { { mine: MyVocab.new, abc: OtherVocab.new } }

    it { within_block_is_expected.not_to raise_exception }

    context 'invalid vocabularies set' do
      let(:vocabularies) { { mine: MyVocab.new, abc: '123' } }

      it { within_block_is_expected.to raise_exception(ControlledVocabulary::Error, 'Invalid controlled vocabularies(s) in vocabulary list: abc') }
    end
  end

  describe '#vocabularies' do
    subject { described_class.vocabularies.keys }

    let(:vocabularies) { {} }

    before do
      described_class.vocabularies = vocabularies
    end

    it { is_expected.to eq([:no_vocabulary]) }

    context 'valid vocabularies set' do
      let(:vocabularies) { { abc: MyVocab.new, other: OtherVocab.new } }

      it { is_expected.to eq([:abc, :other, :no_vocabulary]) }
    end
  end

  describe '#lookup' do
    subject { described_class.lookup(:mine) }

    let(:mine) { MyVocab.new }

    before do
      described_class.vocabularies = { mine: mine }
    end

    it { is_expected.to eq(mine) }

    context 'missing transformation' do
      subject { described_class.lookup(:bogus) }

      it { is_expected.to be_nil }
    end
  end

  describe '#default_key' do
    subject { described_class.default_key }

    it { is_expected.to eq(:no_vocabulary) }
  end
end
