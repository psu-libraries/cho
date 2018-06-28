# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::File::Delete do
  let(:operation) { described_class.new }

  describe '#call' do
    subject { operation.call('file') }

    context 'with a successful delete' do
      its(:success) { is_expected.to eq('file') }
    end

    context 'with a failed delete' do
      before { allow(Dry::Monads::Result::Success).to receive(:new).and_raise(StandardError) }

      its(:failure) { is_expected.to eq('error persisting file') }
    end
  end
end
