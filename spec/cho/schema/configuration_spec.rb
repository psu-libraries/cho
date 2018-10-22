# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Schema::Configuration, type: :model do
  subject(:schema_configuration) { described_class.new(schema_file) }

  let(:schema_file) {}

  its(:schema_config) do
    is_expected.to eq(
      [
        {
          'schema' => 'Generic', 'fields' => {
            'member_of_collection_ids' => { 'order_index' => 2, 'requirement_designation' => 'required' },
            'generic_field' => { 'order_index' => 1 },
            'created' => { 'order_index' => 3 }
          }
        },
        {
          'schema' => 'Document', 'fields' => {
            'member_of_collection_ids' => { 'order_index' => 2, 'requirement_designation' => 'required' },
            'document_field' => { 'order_index' => 1 }
          }
        },
        {
          'schema' => 'Still Image', 'fields' => {
            'member_of_collection_ids' => { 'order_index' => 2, 'requirement_designation' => 'required' },
            'still_image_field' => { 'order_index' => 1, 'display_name' => 'Photograph' }
          }
        },
        {
          'schema' => 'Map', 'fields' => {
            'member_of_collection_ids' => { 'order_index' => 2, 'requirement_designation' => 'required' },
            'map_field' => { 'order_index' => 1 }
          }
        },
        {
          'schema' => 'Moving Image', 'fields' => {
            'member_of_collection_ids' => { 'order_index' => 2, 'requirement_designation' => 'required' },
            'moving_image_field' => { 'order_index' => 1 }
          }
        },
        {
          'schema' => 'Audio', 'fields' => {
            'member_of_collection_ids' => { 'order_index' => 2, 'requirement_designation' => 'required' },
            'subtitle' => { 'order_index' => 25, 'display_name' => 'Additional Info' },
            'audio_field' => { 'order_index' => 1 }
          }
        },
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

  describe '#core_field_ids' do
    it 'does not create more fields since the defaults were loaded' do
      expect {
        expect(schema_configuration.core_field_ids('Generic').count).to eq(4)
        expect(schema_configuration.core_field_count('Generic')).to eq(4)
      }.to change { Valkyrie.config.metadata_adapter.query_service.find_all.count }.by(0)
    end
  end

  context 'another schema is specified' do
    let(:yaml_text) { "test:\n  - schema: 'Other'\n    fields:\n      other_field:\n        order_index: 1\n"\
                      "      title:\n        order_index: 2\n        display_name: my title" }
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
      is_expected.to eq([{ 'schema' => 'Other',
                           'fields' => { 'other_field' => { 'order_index' => 1 },
                                         'title' => { 'display_name' => 'my title', 'order_index' => 2 } } }])
    end

    describe '#load_work_types' do
      let(:other_field) { create :data_dictionary_field, label: 'other_field' }
      let(:title_field) { Schema::MetadataField.where(label: 'title', work_type: 'Other').first }

      before do
        other_field
      end
      it 'adds a Schema::MetadataField, a Work::Type, and a Schema::Metadata' do
        expect {
          schema_configuration.load_work_types
        }.to change { Schema::MetadataField.all.count }.by(5) # 4 core fields + 1 other field
          .and change { Work::Type.all.count }.by(1)
          .and change { Schema::Metadata.all.count }.by(1)
          .and change { Valkyrie.config.metadata_adapter.query_service.find_all.count }.by(7)
        expect(title_field.display_name).to eq('my title')
      end
    end
  end
end
