# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Shared::CreateChangeSet do
  let(:operation) { described_class.new }

  describe '#call' do
    subject { operation.call(resource) }

    context 'when the resource is a work' do
      let(:resource) { Work::Submission.new }

      its(:success) { is_expected.to be_a(Work::SubmissionChangeSet) }
    end

    context 'when the resource is a data dictionary field' do
      let(:resource) { DataDictionary::Field.new }

      its(:success) { is_expected.to be_a(DataDictionary::FieldChangeSet) }
    end

    context 'when the resource is a random object' do
      let(:resource) { 'abc123' }

      its(:success) { is_expected.to be_a(Valkyrie::ChangeSet) }
    end
  end
end
