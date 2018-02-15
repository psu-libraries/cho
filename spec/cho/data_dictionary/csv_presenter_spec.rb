# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::CsvPresenter do
  let(:metdata_field1) { build :data_dictionary_field }
  let(:presenter) { described_class.new(field_list) }
  let(:header) { "Label,Field Type,Requirement Designation,Validation,Multiple,Controlled Vocabulary,Default Value,Display Name,Display Transformation,Index Type,Help Text,Core Field\n" }
  let(:csv_field1) { "abc123_label,date,recommended,no_validation,false,no_vocabulary,abc123,My Abc123,no_transformation,no_facet,help me,false\n" }

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
      let(:metdata_field2) { build :data_dictionary_field, label: 'field2' }
      let(:csv_field2) { "field2,date,recommended,no_validation,false,no_vocabulary,abc123,My Abc123,no_transformation,no_facet,help me,false\n" }

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
