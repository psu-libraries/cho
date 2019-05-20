# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Rejection do
  let(:rejection) { described_class.new('An error message from a transaction', error) }
  let(:error) { StandardError.new('the error message') }

  describe '#initialize' do
    before { allow(ErrorReportingService).to receive(:call) }

    context 'in test environment' do
      it 'traps the error' do
        expect { rejection }.not_to raise_error
      end

      it 'does not report the error to an external service' do
        expect(ErrorReportingService).not_to receive(:call)
        rejection
      end
    end

    context 'in development environment' do
      before { allow(Rails).to receive(:env) { 'development'.inquiry } }

      it 'raises the given error immediately' do
        expect { rejection }.to raise_error(error)
      end

      it 'does not report the error to an external service' do
        expect(ErrorReportingService).not_to receive(:call)

        # Yes this is a duplicate of the test above, but it's also the easiest
        # way to rescue the exception that we expect this call to raise
        expect { rejection }.to raise_error(error)
      end
    end

    context 'in production and other environments' do
      before { allow(Rails).to receive(:env) { 'production'.inquiry } }

      it 'traps the error' do
        expect { rejection }.not_to raise_error
      end

      it 'does not report the error to an external service' do
        expect(ErrorReportingService).to receive(:call).with(error)
        rejection
      end
    end
  end

  describe '#errors' do
    subject { rejection.errors }

    its(:messages) { is_expected.to eq(transaction: ['An error message from a transaction: the error message']) }
  end

  describe '#to_s' do
    subject { rejection.to_s }

    it { is_expected.to eq('An error message from a transaction: the error message') }
  end
end
