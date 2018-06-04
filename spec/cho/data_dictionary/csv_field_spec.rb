# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::CsvField do
  let (:field) { build :data_dictionary_field }
  let (:attributes) { described_class.default_attributes }
  let (:field_attributes) { field.attributes.slice(*attributes) }

  let(:csv_line) do
    'abc123_label,date,recommended,no_validation,false,no_vocabulary,abc123,My Abc123,'\
    "no_transformation,no_facet,help me,false\n"
  end

  describe '#to_csv' do
    subject { described_class.new(field).to_csv }

    it { is_expected.to eq(csv_line) }
  end

  describe '#parse' do
    subject { parsed_model.attributes.slice(*attributes) }

    let(:parsed_model) { described_class.new(DataDictionary::Field.new).parse(csv_line) }

    it { is_expected.to eq(field_attributes) }

    context 'non default attributes' do
      let(:csv_line) { "abc123_label,date,no_validation,no_vocabulary,no_transformation,no_facet,help me,false\n" }
      let(:attributes) { [:label, :field_type, :validation, :controlled_vocabulary, :display_transformation] }
      let(:parsed_model) { described_class.new(DataDictionary::Field.new, attributes).parse(csv_line) }

      it { is_expected.to eq(field_attributes) }
    end
  end
end
