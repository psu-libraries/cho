# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::Import::CsvDryRunResultsPresenter do
  subject { described_class.new(mock_dry_run) }

  let(:mock_dry_run) { instance_double(Agent::Import::CsvDryRun, results: [change_set], update?: false) }

  context 'when there is valid csv data' do
    let(:change_set) do
      change_set = Agent::ChangeSet.new(Agent::Resource.new)
      change_set.validate(given_name: 'Joe', surname: 'Bob')
      change_set
    end

    its(:invalid_rows) { is_expected.to be_empty }
    its(:invalid?) { is_expected.to be_falsey }
    its(:valid?) { is_expected.to be_truthy }
    its(:error_count) { is_expected.to eq 0 }
    its(:valid_rows) { is_expected.to eq [change_set] }
  end

  context 'when there is invalid csv data' do
    let(:change_set) do
      change_set = Agent::ChangeSet.new(Agent::Resource.new)
      change_set.validate(given_name: '', surname: 'Bob')
      change_set
    end

    its(:valid_rows) { is_expected.to be_empty }
    its(:invalid?) { is_expected.to be_truthy }
    its(:valid?) { is_expected.to be_falsey }
    its(:error_count) { is_expected.to eq 1 }
    its(:invalid_rows) { is_expected.to eq [change_set] }
  end
end
