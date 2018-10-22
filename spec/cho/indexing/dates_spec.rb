# frozen_string_literal: true

require 'rails_helper'

describe Indexing::Dates, type: :model do
  let(:resource) { Work::Submission.new }
  let(:indexer) { described_class.new(resource: resource) }

  describe '#to_solr' do
    subject { indexer.to_solr }

    context 'when the field is empty' do
      it { is_expected.to eq({}) }
    end

    context 'when the field has a full date' do
      before { resource.created = ['2001-01-02'] }

      it { is_expected.to eq('created_dtsim' => ['2001-01-02T00:00:00Z']) }
    end

    context 'when the field has multiple full dates' do
      before { resource.created = ['2001-01-02', '1967-12-31'] }

      it { is_expected.to eq('created_dtsim' => ['2001-01-02T00:00:00Z', '1967-12-31T00:00:00Z']) }
    end

    context 'with an unspecified month and day' do
      before { resource.created = ['1992-uu-uu'] }

      it { is_expected.to eq('created_dtsim' => ['1992-01-01T00:00:00Z']) }
    end

    context 'with an uncertain year' do
      before { resource.created = ['1938?'] }

      it { is_expected.to eq('created_dtsim' => ['1938-01-01T00:00:00Z']) }
    end

    context 'with an approximate year and month' do
      before { resource.created = ['1984?-06~'] }

      it { is_expected.to eq('created_dtsim' => ['1984-06-01T00:00:00Z']) }
    end

    context 'with only year and month' do
      before { resource.created = ['2006-11'] }

      it { is_expected.to eq('created_dtsim' => ['2006-11-01T00:00:00Z']) }
    end

    context 'with only a year' do
      before { resource.created = ['2002'] }

      it { is_expected.to eq('created_dtsim' => ['2002-01-01T00:00:00Z']) }
    end

    context 'with an unparseable date' do
      before { resource.created = ['asdf'] }

      it { is_expected.to eq({}) }
    end

    context 'with Time object' do
      let(:converted_time) { Time.new('2010-05-05').utc.strftime('%Y-%m-%dT%H:%M:%SZ') }

      before { resource.created = [Time.new('2010-05-05')] }

      it { is_expected.to eq('created_dtsim' => [converted_time]) }
    end

    context 'with a singular field' do
      let(:resource) { SingleDateResource.new }

      before do
        class SingleDateResource < Valkyrie::Resource
          attribute :single_date
        end

        create(:schema_metadata_field, label: 'single_date', index_type: 'date', multiple: false)
        resource.single_date = '1960'
      end

      after { ActiveSupport::Dependencies.remove_constant('SingleDateResource') }

      it { is_expected.to eq('single_date_dtsi' => '1960-01-01T00:00:00Z') }
    end
  end
end
