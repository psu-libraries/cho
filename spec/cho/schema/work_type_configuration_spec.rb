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

    it do
      is_expected.to eq(
        'member_of_collection_ids' => { 'order_index' => 2, 'requirement_designation' => 'required' },
        'still_image_field' => { 'display_name' => 'Photograph', 'order_index' => 1 }
      )
    end

    context 'a non existing work type' do
      let(:work_type) { 'Foo' }

      it { is_expected.to be_nil }
    end

    context 'a work type with overridden core fields' do
      let(:work_type) { 'Audio' }

      it do
        is_expected.to eq(
          'audio_field' => { 'order_index' => 1 },
          'member_of_collection_ids' => { 'order_index' => 2, 'requirement_designation' => 'required' },
          'subtitle' => { 'display_name' => 'Additional Info', 'order_index' => 25 }
        )
      end
    end
  end

  describe '#initialize_schema_fields' do
    subject(:schema_fields) { work_type_configuration.initialize_schema_fields }

    let(:work_type) { 'Generic' }

    it 'creates a field based on the work type' do
      expect(schema_fields.count).to eq(3)
      expect(schema_fields[0].order_index).to eq(6)
      expect(schema_fields[0].label).to eq('generic_field')
      expect(schema_fields[0].work_type).to eq(work_type)
      expect(schema_fields[0].requirement_designation).to eq('optional')
      expect(schema_fields[1].order_index).to eq(7)
      expect(schema_fields[1].label).to eq('member_of_collection_ids')
      expect(schema_fields[1].work_type).to eq(work_type)
      expect(schema_fields[1].requirement_designation).to eq('required')
    end

    context 'a non existing work type' do
      let(:work_type) { 'Foo' }

      it { is_expected.to eq([]) }
    end

    context 'a work type with overridden core fields' do
      let(:work_type) { 'Audio' }

      it 'creates a field based on the work type' do
        expect(schema_fields.count).to eq(3)
        expect(schema_fields.map(&:order_index)).to contain_exactly(25, 6, 7)
        expect(schema_fields.map(&:label)).to contain_exactly('subtitle', 'audio_field', 'member_of_collection_ids')
        expect(schema_fields.map(&:work_type).uniq).to contain_exactly(work_type)
        expect(schema_fields.map(&:display_name)).to contain_exactly('Additional Info', nil, 'Member of Collection')
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
      expect(metadata_schema.fields.count).to eq(3)
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
        expect(metadata_schema.fields.count).to eq(3)
        field = Schema::MetadataField.find(Valkyrie::ID.new(metadata_schema.fields.first.id))
        expect(field.order_index).to eq(25)
        expect(field.label).to eq('subtitle')
        expect(field.display_name).to eq('Additional Info')
        expect(field.work_type).to eq(work_type)
      end
    end
  end
end
