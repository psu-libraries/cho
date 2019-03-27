# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvDryRunResultsPresenter do
  subject { described_class.new(mock_dry_run) }

  let(:work_type_id) { Work::Type.find_using(label: 'Generic').first.id }
  let(:collection) { create :library_collection }
  let(:change_set) { instance_double(Work::SubmissionChangeSet) }
  let(:mock_dry_run) { instance_double(Work::Import::CsvDryRun, results: [change_set], bag: bag, update?: false) }
  let(:bag) { Dry::Monads::Result::Success.new('success') }

  it { is_expected.to delegate_method(:update?).to(:dry_run) }
  it { is_expected.to delegate_method(:each).to(:change_set_list) }
  it { is_expected.to delegate_method(:to_a).to(:change_set_list) }
  it { is_expected.to delegate_method(:bag).to(:dry_run) }

  context 'when there is valid csv and valid bag data' do
    let(:change_set) do
      change_set = Work::SubmissionChangeSet.new(Work::Submission.new)
      change_set.validate(
        home_collection_id: collection.id, work_type_id: [work_type_id], title: 'My valid work'
      )
      change_set
    end

    its(:invalid_rows) { is_expected.to be_empty }
    its(:invalid?) { is_expected.to be_falsey }
    its(:valid?) { is_expected.to be_truthy }
    its(:error_count) { is_expected.to eq 0 }
    its(:valid_rows) { is_expected.to eq [change_set] }
    its(:bag_errors) { is_expected.to be_empty }
  end

  context 'when there is invalid csv data and valid bag data' do
    let(:change_set) do
      change_set = Work::SubmissionChangeSet.new(Work::Submission.new)
      change_set.validate(home_collection_id: collection.id, title: 'My invalid work')
      change_set
    end

    its(:valid_rows) { is_expected.to be_empty }
    its(:invalid?) { is_expected.to be_truthy }
    its(:valid?) { is_expected.to be_falsey }
    its(:error_count) { is_expected.to eq 1 }
    its(:invalid_rows) { is_expected.to eq [change_set] }
    its(:bag_errors) { is_expected.to be_empty }
  end

  context 'when there is valid csv data and invalid bag data' do
    let(:change_set) do
      change_set = Work::SubmissionChangeSet.new(Work::Submission.new)
      change_set.validate(
        home_collection_id: collection.id, work_type_id: [work_type_id], title: 'My valid work'
      )
      change_set
    end

    let(:mock_failure) { instance_double(Import::Bag, errors: { work: 'Error message' }) }
    let(:bag) { Dry::Monads::Result::Failure.new(mock_failure) }

    its(:invalid_rows) { is_expected.to be_empty }
    its(:error_count) { is_expected.to eq 0 }
    its(:valid_rows) { is_expected.to eq [change_set] }
    its(:invalid?) { is_expected.to be_truthy }
    its(:valid?) { is_expected.to be_falsey }
    its(:bag_errors) { is_expected.to contain_exactly('Error message') }
  end
end
