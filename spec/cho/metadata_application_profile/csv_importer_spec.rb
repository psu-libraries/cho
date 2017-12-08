# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataApplicationProfile::CsvImporter do
  let(:header) { "Label,Field Type,Requirement Designation,Validation,Multiple,Controlled Vocabulary,Default Value,Display Name,Display Transformation\n" }
  let(:csv_field1) { "abc123_label,date,recommended,no_validation,false,no_vocabulary,abc123,My Abc123,no_transformation\n" }

  let(:file) { StringIO.new(header + csv_field1) }

  let(:importer) { described_class.new(file) }

  it 'parses a file' do
    expect {
      importer.import
    }.to change(MetadataApplicationProfile::Field, :count).by(1)
  end

  context 'record exists' do
    before { create(:metadata_application_profile_field) }

    it 'will update records' do
      expect {
        importer.import
      }.to change(MetadataApplicationProfile::Field, :count).by(0)
    end
  end

  context 'no header line' do
    let(:file) { StringIO.new(csv_field1) }

    it 'uses the default' do
      expect {
        importer.import
      }.to change(MetadataApplicationProfile::Field, :count).by(1)
    end
  end

  context 'incorrect fields' do
    let(:csv_field1) { "abc123_label,date,recommended,unknown_validation,false,no_vocabulary,abc123,My Abc123,no_transformation\n" }
    let(:file) { StringIO.new(csv_field1) }

    it 'uses the default' do
      expect {
        importer.import
      }.to change(MetadataApplicationProfile::Field, :count).by(0).and(raise_error(Dry::Struct::Error))
    end
  end
end
