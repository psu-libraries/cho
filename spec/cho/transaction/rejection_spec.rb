# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Rejection do
  let(:failure) { described_class.new('An error message from a transaction') }

  describe '#errors' do
    subject { failure.errors }

    its(:messages) { is_expected.to eq(transaction: ['An error message from a transaction']) }
  end

  describe '#to_s' do
    subject { failure.to_s }

    it { is_expected.to eq('An error message from a transaction') }
  end
end
