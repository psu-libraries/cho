# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisplayTransformation::Factory, type: :model do
  before (:all) do
    class MyTransformation < DisplayTransformation::Base
    end
    class OtherTransformation < DisplayTransformation::Base
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyTransformation')
    ActiveSupport::Dependencies.remove_constant('OtherTransformation')
  end

  subject(:factory) { described_class.new }

  it { within_block_is_expected.not_to raise_exception }

  describe '#tranformations=' do
    subject { described_class.transformations = transformations }

    let(:transformations) { { mine: MyTransformation.new, abc: OtherTransformation.new } }

    it { within_block_is_expected.not_to raise_exception }

    context 'invalid transformations set' do
      let(:transformations) { { mine: MyTransformation.new, abc: '123' } }

      it { within_block_is_expected.to raise_exception(DisplayTransformation::Error, 'Invalid display transformation(s) in transformation list: abc') }
    end
  end

  describe '#tranformations' do
    subject { described_class.transformations.keys }

    let(:transformations) { {} }

    before do
      described_class.transformations = transformations
    end

    it { is_expected.to eq([:none]) }

    context 'valid transformations set' do
      let(:transformations) { { abc: MyTransformation.new, other: OtherTransformation.new } }

      it { is_expected.to eq([:abc, :other, :none]) }
    end
  end

  describe '#lookup' do
    subject { described_class.lookup(:mine) }

    let(:mine) { MyTransformation.new }

    before do
      described_class.transformations = { mine: mine }
    end

    it { is_expected.to eq(mine) }

    context 'missing transformation' do
      subject { described_class.lookup(:bogus) }

      it { is_expected.to be_nil }
    end
  end
end
