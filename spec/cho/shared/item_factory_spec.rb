# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemFactory, type: :model do
  describe '#default_items' do
    subject { described_class.send(:default_items) }

    it { within_block_is_expected.to raise_exception(NotImplementedError) }
  end

  describe '#item_class' do
    subject { described_class.send(:item_class) }

    it { within_block_is_expected.to raise_exception(NotImplementedError) }
  end

  describe '#send_error' do
    subject { described_class.send(:send_error, 'error') }

    it { within_block_is_expected.to raise_exception(NotImplementedError) }
  end

  describe '#items=' do
    subject { described_class.items = { other: Date.new } }

    it { within_block_is_expected.to raise_exception(NotImplementedError) }
  end

  describe '#items' do
    subject { described_class.items = { other: Date.new } }

    it { within_block_is_expected.to raise_exception(NotImplementedError) }
  end

  context 'class implementing ItemFactory' do
    let(:default_date) { MyItemFactory.default_date }

    before do
      class MyItemFactory < ItemFactory
        class << self
          def default_date
            Date.new
          end

          def item_class
            Date
          end

          def default_key
            :my_item
          end

          def default_items
            { default_key => default_date }
          end

          def send_error(error)
            raise(error)
          end
        end
      end
    end

    after do
      ActiveSupport::Dependencies.remove_constant('MyItemFactory')
    end

    describe '#items=' do
      subject { MyItemFactory.items = items }

      let(:items) { { other: Date.new } }

      it { within_block_is_expected.not_to raise_exception }

      context 'bad items' do
        let(:items) { { other: Date.new, bad: 'abc' } }

        it { within_block_is_expected.to raise_exception(StandardError) }
      end
    end

    describe '#items' do
      subject { MyItemFactory.items }

      it { is_expected.to eq(my_item: default_date) }
    end

    describe '#lookup' do
      subject { MyItemFactory.lookup(:my_item) }

      it { is_expected.to eq(default_date) }
    end

    describe '#names' do
      subject { MyItemFactory.names }

      it { is_expected.to eq(['my_item']) }
    end

    describe '#default_key' do
      subject { MyItemFactory.default_key }

      it { is_expected.to eq(:my_item) }
    end
  end

  describe '#default_key' do
    subject { described_class.default_key }

    it { within_block_is_expected.to raise_exception(NotImplementedError) }
  end
end
