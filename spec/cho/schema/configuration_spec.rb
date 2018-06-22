# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Schema::Configuration, type: :model do
  subject(:schema_configuration) { described_class.new(schema_file) }

  let(:schema_file) {}

  its(:schema_config) do
    is_expected.to eq(
      [
        { 'schema' => 'Generic', 'fields' => { 'generic_field' => { 'order_index' => 1 } } },
        { 'schema' => 'Document', 'fields' => { 'document_field' => { 'order_index' => 1 } } },
        { 'schema' => 'Still Image',
          'fields' => { 'still_image_field' => { 'order_index' => 1, 'display_name' => 'Photograph' } } },
        { 'schema' => 'Map', 'fields' => { 'map_field' => { 'order_index' => 1 } } },
        { 'schema' => 'Moving Image',
          'fields' => { 'moving_image_field' => { 'order_index' => 1 } } },
        { 'schema' => 'Audio', 'fields' => { 'audio_field' => { 'order_index' => 1 } } },
        { 'schema' => 'Collection', 'fields' => [], 'work_type' => 'false' },
        { 'schema' => 'FileSet', 'fields' => [], 'work_type' => 'false' }
      ]
    )
  end

  describe '#schemas' do
    it 'reads each schema from the config file' do
      expect(schema_configuration.schemas.first).to be_a(Struct::Schema)
      expect(schema_configuration.schemas.map(&:type)).to contain_exactly(
        'Generic', 'Document', 'Still Image', 'Map', 'Moving Image', 'Audio', 'Collection', 'FileSet'
      )
      expect(schema_configuration.schemas.select { |s| s.type == 'Generic' }.first).to be_work_type
      expect(schema_configuration.schemas.select { |s| s.type == 'Document' }.first).to be_work_type
      expect(schema_configuration.schemas.select { |s| s.type == 'Still Image' }.first).to be_work_type
      expect(schema_configuration.schemas.select { |s| s.type == 'Map' }.first).to be_work_type
      expect(schema_configuration.schemas.select { |s| s.type == 'Moving Image' }.first).to be_work_type
      expect(schema_configuration.schemas.select { |s| s.type == 'Audio' }.first).to be_work_type
      expect(schema_configuration.schemas.select { |s| s.type == 'Collection' }.first).not_to be_work_type
      expect(schema_configuration.schemas.select { |s| s.type == 'FileSet' }.first).not_to be_work_type
    end
  end

  describe '#load_work_types' do
    it 'does nothing since the default types were already loaded' do
      expect {
        schema_configuration.load_work_types
      }.to change { Valkyrie.config.metadata_adapter.query_service.find_all.count }.by(0)
    end
  end

  context 'another schema is specified' do
    let(:yaml_text) { "test:\n  - schema: 'Other'\n    fields:\n      other_field:\n        order_index: 1" }
    let(:schema) do
      file = Tempfile.new
      file.write(yaml_text)
      file.close
      file
    end

    let(:schema_file) { schema.path }

    after do
      schema.unlink
    end

    its(:schema_config) do
      is_expected.to eq([{ 'schema' => 'Other', 'fields' => { 'other_field' => { 'order_index' => 1 } } }])
    end

    describe '#load_work_types' do
      let(:other_field) { create :data_dictionary_field, label: 'other_field' }

      before do
        other_field
      end
      it 'adds a Schema::MetadataField, a Work::Type, and a Schema::Metadata' do
        expect {
          schema_configuration.load_work_types
        }.to change { Schema::MetadataField.all.count }.by(1)
          .and change { Work::Type.all.count }.by(1)
          .and change { Schema::Metadata.all.count }.by(1)
          .and change { Valkyrie.config.metadata_adapter.query_service.find_all.count }.by(3)
      end
    end
  end
end
