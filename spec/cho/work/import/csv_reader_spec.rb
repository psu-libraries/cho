# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Import::CsvReader do
  let(:reader) { described_class.new(csv_file) }
  let(:csv_file) { StringIO.new("id,member_of_collection_ids\ndata1,data2\ndataA,dataB") }
  let(:csv_hash) do
    [
      { 'id' => 'data1', 'member_of_collection_ids' => 'data2' },
      { 'id' => 'dataA', 'member_of_collection_ids' => 'dataB' }
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
    it 'map the data array' do
      data = reader.map do |hash|
        hash
      end
      expect(data).to eq(csv_hash)
    end
  end

  describe '#headers' do
    subject { reader.headers }

    it { is_expected.to eq(['id', 'member_of_collection_ids']) }
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

  context 'with one work and multiple file sets' do
    subject { reader }

    let(:csv_file) { StringIO.new("id,member_of_collection_ids\nworkID,1\nworkID_01_01,\nworkID_01_02,") }

    its(:work_hashes) { is_expected.to contain_exactly('id' => 'workID', 'member_of_collection_ids' => '1') }
    its(:file_set_hashes) { is_expected.to contain_exactly(
      { 'id' => 'workID_01_01', 'member_of_collection_ids' => nil },
      'id' => 'workID_01_02', 'member_of_collection_ids' => nil
    )}
  end
end
