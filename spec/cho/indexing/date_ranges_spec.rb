# frozen_string_literal: true

require 'rails_helper'

describe Indexing::DateRanges, type: :model do
  let(:resource) { Work::Submission.new }
  let(:indexer) { described_class.new(resource: resource) }

  describe '#to_solr' do
    subject { indexer.to_solr }

    context 'when the field is empty' do
      it { is_expected.to eq({}) }
    end

    context 'when the field has a full date' do
      before { resource.created = ['2001-01-02'] }

      it { is_expected.to eq('created_dtrsim' => ['2001-01-02']) }
    end

    context 'when the field has a partial date' do
      before { resource.created = ['2001-01'] }

      it { is_expected.to eq('created_dtrsim' => ['2001-01']) }
    end

    context 'when the field has a uncertain date' do
      before { resource.created = ['2001-01-02?'] }

      it { is_expected.to eq('created_dtrsim' => ['[2001-01-01 TO 2001-01-03]']) }
    end

    context 'when the field has an interval' do
      before { resource.created = ['1965/1975'] }

      it { is_expected.to eq('created_dtrsim' => ['[1965 TO 1975]']) }
    end

    context 'when the field cannot be parsed' do
      before { resource.created = ['crankstations'] }

      it { is_expected.to eq({}) }
    end
  end
end
