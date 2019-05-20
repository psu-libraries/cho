# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Shared::Validate do
  let(:operation) { described_class.new }
  let(:collection) { create :collection }
  let(:change_set) { Work::SubmissionChangeSet.new(resource) }

  describe '#call' do
    subject(:operation_result) { operation.call(change_set) }

    context 'when the resource is a work' do
      let(:resource) { build :work_submission, home_collection_id: [collection.id] }

      its(:success) { is_expected.to be_a(Work::SubmissionChangeSet) }
    end

    context 'when the resource is invalid' do
      let(:resource) { Work::Submission.new({}) }

      it 'returns errors' do
        expect(operation_result.failure.errors.messages).to eq(work_type_id: ["can't be blank"])
      end
    end

    context 'when something raises an error' do
      let(:resource) { Work::Submission.new({}) }

      before { allow(change_set).to receive(:validate).and_raise('blimey!') }

      it 'returns a Failure' do
        expect(operation_result).to be_failure
      end
    end
  end
end
