# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvMetadataFieldListPresenter do
  let(:metdata_field1) { build :metadata_application_profile_field }
  let(:presenter) { described_class.new(field_list) }
  let(:header) { "Label,Field Type,Requirement Designation,Validation,Multiple,Controlled Vocabulary,Default Value,Display Name,Display Transformation\n" }
  let(:csv_field1) { "abc123_label,date,recommended,abc123_validation,false,abc123_vocab,abc123,My Abc123,abc123_transform\n" }

  describe '#to_csv' do
    subject { presenter.to_csv }

    context 'empty list' do
      let(:field_list) { [] }

      it { is_expected.to eq(header) }
    end

    context 'single item in list' do
      let(:field_list) { [metdata_field1] }

      it { is_expected.to eq(header + csv_field1) }
    end

    context 'multiple items in list' do
      let(:field_list) { [metdata_field1, metdata_field2] }
      let(:metdata_field2) { build :metadata_application_profile_field, label: 'field2' }
      let(:csv_field2) { "field2,date,recommended,abc123_validation,false,abc123_vocab,abc123,My Abc123,abc123_transform\n" }

      it { is_expected.to eq(header + csv_field1 + csv_field2) }
    end

    context 'subset of attributes' do
      let(:presenter) { described_class.new(field_list, ['label', 'field_type', 'blarg']) }
      let(:header) { "Label,Field Type\n" }
      let(:csv_field1) { "abc123_label,date\n" }
      let(:field_list) { [metdata_field1] }

      it { is_expected.to eq(header + csv_field1) }
    end

    context 'subset of attributes as symbols' do
      let(:presenter) { described_class.new(field_list, [:label, :field_type, :blarg]) }
      let(:header) { "Label,Field Type\n" }
      let(:csv_field1) { "abc123_label,date\n" }
      let(:field_list) { [metdata_field1] }

      it { is_expected.to eq(header + csv_field1) }
    end
  end
end
