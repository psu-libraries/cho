# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metrics::Repository do
  describe '::reset' do
    context 'when the service instance is not white-listed' do
      it 'prevents you from resetting the repository' do
        expect { described_class.reset }.to raise_error(Metrics::Repository::ResetError)
      end
    end

    context 'when the service instance is white-listed' do
      it 'resets the repository' do
        current = ENV['service_name']
        ENV['service_name'] = 'qa'
        described_class.reset
        ENV['service_name'] = current
      end
    end
  end

  describe '::WHITELIST' do
    subject { Metrics::Repository::WHITELIST }

    it { is_expected.to contain_exactly('localhost', 'qa') }
  end
end
