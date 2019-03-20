# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metrics::Collection do
  let(:metric) { described_class.new(length: 1, output: report) }
  let(:report) { StringIO.new }
  let(:collection) { Collection::Archival.all.first }

  describe '#output' do
    context 'by default' do
      subject(:metric) { described_class.new }

      it 'uses a file for the default report' do
        expect(metric.output.path).to eq('tmp/cho_metrics_collection_10.csv')
      end
    end

    context 'with a custom length' do
      subject(:metric) { described_class.new(length: 100) }

      it 'uses a file with the new length for the default report' do
        expect(metric.output.path).to eq('tmp/cho_metrics_collection_100.csv')
      end
    end
  end

  it 'creates a collection with works and benchmarks the results' do
    expect($stdout).to be(STDOUT)
    metric.run
    header, results = report.string.split("\n")
    expect(header).to eq(' User,System,Total,Real')
    expect(results.split(',').count).to eq(4)
    expect(collection.members.first.title).to contain_exactly('Sample Resource 1')
    expect($stdout).to be(STDOUT)
  end
end
