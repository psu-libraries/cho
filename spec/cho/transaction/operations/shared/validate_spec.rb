# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Shared::Validate do
  let(:operation) { described_class.new }
  let(:collection) { create :collection }

  describe '#call' do
    subject(:operation_result) { operation.call(Work::SubmissionChangeSet.new(resource)) }

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
  end
end
