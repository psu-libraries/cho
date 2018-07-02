# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::File::Validate do
  let(:operation) { described_class.new }

  describe '#call' do
    subject { operation.call(change_set) }

    context 'when the change set supports files' do
      let(:change_set) { instance_double(Work::SubmissionChangeSet) }

      before { allow(change_set).to receive(:file).and_return(['file']) }

      its(:success) { is_expected.to eq(change_set) }
    end

    context 'when the change set does not support files' do
      let(:change_set) { Valkyrie::ChangeSet.new({}) }

      its(:failure) { is_expected.to eq(change_set) }
    end

    context 'when there is an unknown error' do
      let(:change_set) { instance_double(Work::SubmissionChangeSet) }

      before { allow(change_set).to receive(:file).and_raise(StandardError, 'something went wrong') }

      its(:failure) { is_expected.to eq('Error validating file: something went wrong') }
    end
  end
end
