# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::Import::CsvReader do
  let(:reader) { described_class.new(csv_file) }
  let(:csv_file) { StringIO.new("id,given_name,surname\n1,joe,bob\n2,jane,smith") }
  let(:csv_hash) do
    [
      { 'id' => '1', 'given_name' => 'joe', 'surname' => 'bob' },
      { 'id' => '2', 'given_name' => 'jane', 'surname' => 'smith' }
    ]
  end

  describe '#each' do
    it 'iterates over the data' do
      data = []
      reader.each do |hash|
        data << hash
      end
      expect(data).to eq(csv_hash)
    end
  end

  describe '#map' do
    it 'maps the data array' do
      data = reader.map do |hash|
        hash
      end
      expect(data).to eq(csv_hash)
    end
  end

  describe '#headers' do
    subject { reader.headers }

    it { is_expected.to eq(['id', 'given_name', 'surname']) }
  end

  describe '#csv_hashes' do
    subject { reader.csv_hashes }

    it { is_expected.to eq(csv_hash) }

    context 'value has multiple items' do
      let(:csv_file) { StringIO.new("header1,header2\ndata1,data2\ndataA1|dataA2,dataB") }
      let(:csv_hash) do
        [{ 'header1' => 'data1', 'header2' => 'data2' }, { 'header1' => ['dataA1', 'dataA2'], 'header2' => 'dataB' }]
      end

      it { is_expected.to eq(csv_hash) }
    end
  end
end
