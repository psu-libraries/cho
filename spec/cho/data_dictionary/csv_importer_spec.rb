# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::CsvImporter do
  let(:header) { "Label,Field Type,Requirement Designation,Validation,Multiple,Controlled Vocabulary,Default Value,Display Name,Display Transformation,Index Type,Help Text,Core Field\n" }
  let(:csv_field1) { "abc123_label,date,recommended,no_validation,false,no_vocabulary,abc123,My Abc123,no_transformation,no_facet,help me,false\n" }

  let(:file) { StringIO.new(header + csv_field1) }

  let(:importer) { described_class.new(file) }

  it 'parses a file' do
    expect {
      importer.import
    }.to change(DataDictionary::Field, :count).by(1)
  end

  context 'record exists' do
    before { create(:data_dictionary_field) }

    it 'will update records' do
      expect {
        importer.import
      }.to change(DataDictionary::Field, :count).by(0)
    end
  end

  context 'no header line' do
    let(:file) { StringIO.new(csv_field1) }

    it 'uses the default' do
      expect {
        importer.import
      }.to change(DataDictionary::Field, :count).by(1)
    end
  end

  context 'incorrect fields' do
    let(:csv_field1) { "abc123_label,date,recommended,unknown_validation,false,no_vocabulary,abc123,My Abc123,no_transformation\n" }
    let(:file) { StringIO.new(csv_field1) }

    it 'uses the default' do
      expect {
        importer.import
      }.to change(DataDictionary::Field, :count).by(0).and(raise_error(Dry::Struct::Error))
    end
  end

  describe 'load_dictionary' do
    it 'loads the default (which is already loaded)' do
      expect {
        described_class.load_dictionary
      }.to change(DataDictionary::Field, :count).by(0)
    end

    context 'another file' do
      let(:csv_file) do
        file = Tempfile.new
        file.write(header)
        file.write(csv_field1)
        file.close
        file
      end

      after do
        csv_file.unlink
      end

      it 'loads the new fields' do
        expect {
          described_class.load_dictionary(csv_file.path)
        }.to change(DataDictionary::Field, :count).by(1)
      end
    end
  end
end
