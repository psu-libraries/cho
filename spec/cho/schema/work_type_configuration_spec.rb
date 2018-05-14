# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Schema::WorkTypeConfiguration, type: :model do
  subject(:work_type_configuration) { described_class.new(schema_configuration: Schema::Configuration.new, work_type: work_type) }

  describe '#fields' do
    subject { work_type_configuration.fields }

    let(:work_type) { 'Still Image' }

    it { is_expected.to eq('still_image_field' => { 'order_index' => 1, 'display_name' => 'Photograph' }) }

    context 'a non existing work type' do
      let(:work_type) { 'Foo' }

      it { is_expected.to be_nil }
    end
  end

  describe '#initialize_schema_fields' do
    subject(:schema_fields) { work_type_configuration.initialize_schema_fields }

    let(:work_type) { 'Generic' }

    it 'creates a field based on the work type' do
      expect(schema_fields.count).to eq(1)
      expect(schema_fields.first.order_index).to eq(4)
      expect(schema_fields.first.label).to eq('generic_field')
    end

    context 'a non existing work type' do
      let(:work_type) { 'Foo' }

      it { is_expected.to eq([]) }
    end
  end

  describe '#generate_work_type' do
    subject(:work_type_schema) { work_type_configuration.generate_work_type }

    let(:work_type) { 'Generic' }

    it 'creates a field based on the work type' do
      expect(work_type_schema).to be_a(Work::Type)
      expect(work_type_schema.label).to eq(work_type)
    end

    context 'a non existing work type' do
      let(:work_type) { 'Foo' }

      it { is_expected.to be_nil }
    end
  end

  describe '#generate_metadata_schema' do
    subject(:metadata_schema) { work_type_configuration.generate_metadata_schema }

    let(:work_type) { 'Generic' }

    it 'creates a field based on the work type' do
      expect(metadata_schema).to be_a(Schema::Metadata)
      expect(metadata_schema.label).to eq(work_type)
      expect(metadata_schema.fields.count).to eq(1)
    end

    context 'a non existing work type' do
      let(:work_type) { 'Foo' }

      it 'creates a field based on the work type' do
        expect(metadata_schema).to be_a(Schema::Metadata)
        expect(metadata_schema.label).to eq(work_type)
        expect(metadata_schema.fields.count).to eq(0)
      end
    end
  end
end
