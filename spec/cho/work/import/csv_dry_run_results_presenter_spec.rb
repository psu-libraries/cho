# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvDryRunResultsPresenter do
  subject { described_class.new([valid_changeset]) }

  let(:valid_changeset) do
    change_set = Work::SubmissionChangeSet.new(Work::Submission.new)
    change_set.validate(member_of_collection_ids: [collection.id], work_type_id: [work_type_id], title: 'My valid work')
    change_set
  end

  let(:collection) { create :library_collection }
  let(:work_type_id) { Work::Type.find_using(label: 'Generic').first.id }

  its(:invalid_rows) { is_expected.to be_empty }
  its(:invalid?) { is_expected.to be_falsey }
  its(:error_count) { is_expected.to eq 0 }
  its(:valid_rows) { is_expected.to eq [valid_changeset] }

  context 'when there is invalid data' do
    subject { described_class.new([invalid_changeset]) }

    let(:invalid_changeset) do
      change_set = Work::SubmissionChangeSet.new(Work::Submission.new)
      change_set.validate(member_of_collection_ids: [collection.id], title: 'My invalid work')
      change_set
    end

    its(:valid_rows) { is_expected.to be_empty }
    its(:invalid?) { is_expected.to be_truthy }
    its(:error_count) { is_expected.to eq 1 }
    its(:invalid_rows) { is_expected.to eq [invalid_changeset] }
  end
end
