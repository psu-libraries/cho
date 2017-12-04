# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataApplicationProfile::CsvField do
  let (:field) { build :metadata_application_profile_field }
  let (:attributes) { described_class.default_attributes }
  let (:field_attributes) { field.attributes.slice(*attributes) }
  let(:csv_line) { "abc123_label,date,recommended,no_validation,false,no_vocabulary,abc123,My Abc123,abc123_transform\n" }

  describe '#to_csv' do
    subject { described_class.new(field).to_csv }

    it { is_expected.to eq(csv_line) }
  end

  describe '#parse' do
    subject { parsed_model.attributes.slice(*attributes) }

    let(:parsed_model) { described_class.new(MetadataApplicationProfile::Field.new).parse(csv_line) }

    it { is_expected.to eq(field_attributes) }

    context 'non default attributes' do
      let(:csv_line) { "abc123_label,date,no_validation,no_vocabulary\n" }
      let(:attributes) { [:label, :field_type, :validation, :controlled_vocabulary] }
      let(:parsed_model) { described_class.new(MetadataApplicationProfile::Field.new, attributes).parse(csv_line) }

      it { is_expected.to eq(field_attributes) }
    end
  end
end
