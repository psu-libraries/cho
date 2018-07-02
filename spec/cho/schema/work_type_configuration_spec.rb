# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Schema::WorkTypeConfiguration, type: :model do
  subject(:work_type_configuration) do
    described_class.new(schema_configuration: Schema::Configuration.new, work_type: work_type)
  end

  describe '#fields' do
    subject { work_type_configuration.fields }

    let(:work_type) { 'Still Image' }

    it { is_expected.to eq('still_image_field' => { 'order_index' => 1, 'display_name' => 'Photograph' }) }

    context 'a non existing work type' do
      let(:work_type) { 'Foo' }

      it { is_expected.to be_nil }
    end

    context 'a work type with overridden core fields' do
      let(:work_type) { 'Audio' }

      it { is_expected.to eq('audio_field' => { 'order_index' => 1 },
                             'subtitle' => { 'order_index' => 25, 'display_name' => 'Additional Info' }) }
    end
  end

  describe '#initialize_schema_fields' do
    subject(:schema_fields) { work_type_configuration.initialize_schema_fields }

    let(:work_type) { 'Generic' }

    it 'creates a field based on the work type' do
      expect(schema_fields.count).to eq(1)
      expect(schema_fields.first.order_index).to eq(4)
      expect(schema_fields.first.label).to eq('generic_field')
      expect(schema_fields.first.work_type).to eq(work_type)
    end

    context 'a non existing work type' do
      let(:work_type) { 'Foo' }

      it { is_expected.to eq([]) }
    end

    context 'a work type with overridden core fields' do
      let(:work_type) { 'Audio' }

      it 'creates a field based on the work type' do
        expect(schema_fields.count).to eq(2)
        expect(schema_fields.first.order_index).to eq(25)
        expect(schema_fields.first.label).to eq('subtitle')
        expect(schema_fields.first.work_type).to eq(work_type)
        expect(schema_fields.first.display_name).to eq('Additional Info')
        expect(schema_fields.last.order_index).to eq(4)
        expect(schema_fields.last.label).to eq('audio_field')
        expect(schema_fields.last.work_type).to eq(work_type)
      end
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

    context 'a work type with overridden core fields' do
      let(:work_type) { 'Audio' }

      it 'creates a field based on the work type' do
        expect(metadata_schema).to be_a(Schema::Metadata)
        expect(metadata_schema.label).to eq(work_type)
        expect(metadata_schema.fields.count).to eq(2)
        field = Schema::MetadataField.find(Valkyrie::ID.new(metadata_schema.fields.first.id))
        expect(field.order_index).to eq(25)
        expect(field.label).to eq('subtitle')
        expect(field.display_name).to eq('Additional Info')
        expect(field.work_type).to eq(work_type)
      end
    end
  end
end
