# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvDryRunResultsPresenter do
  subject { described_class.new(mock_dry_run) }

  let(:work_type_id) { Work::Type.find_using(label: 'Generic').first.id }
  let(:collection) { create :library_collection }
  let(:change_set) { instance_double(Work::SubmissionChangeSet) }
  let(:mock_dry_run) { instance_double(Work::Import::CsvDryRun, results: [change_set]) }

  it { is_expected.to delegate_method(:update?).to(:dry_run) }
  it { is_expected.to delegate_method(:each).to(:change_set_list) }
  it { is_expected.to delegate_method(:to_a).to(:change_set_list) }

  context 'when there is valid data' do
    let(:change_set) do
      change_set = Work::SubmissionChangeSet.new(Work::Submission.new)
      change_set.validate(member_of_collection_ids: [collection.id], work_type_id: [work_type_id], title: 'My valid work')
      change_set
    end

    its(:invalid_rows) { is_expected.to be_empty }
    its(:invalid?) { is_expected.to be_falsey }
    its(:error_count) { is_expected.to eq 0 }
    its(:valid_rows) { is_expected.to eq [change_set] }
  end

  context 'when there is invalid data' do
    let(:change_set) do
      change_set = Work::SubmissionChangeSet.new(Work::Submission.new)
      change_set.validate(member_of_collection_ids: [collection.id], title: 'My invalid work')
      change_set
    end

    its(:valid_rows) { is_expected.to be_empty }
    its(:invalid?) { is_expected.to be_truthy }
    its(:error_count) { is_expected.to eq 1 }
    its(:invalid_rows) { is_expected.to eq [change_set] }
  end
end
