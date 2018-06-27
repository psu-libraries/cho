# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Schema::Metadata, type: :model do
  subject { model }

  let(:resource_klass) { described_class }
  let(:model) { build :schema_metadata,
                      label: 'abc123_label',
                      core_fields: core_fields,
                      fields: fields }
  let(:core_fields) { [build(:schema_metadata_field, label: 'core1')] }
  let(:fields) { [build(:schema_metadata_field, label: 'field1')] }

  it_behaves_like 'a Valkyrie::Resource'

  it { is_expected.to respond_to(:label) }
  it { is_expected.to respond_to(:core_fields) }

  context 'when saving with metadata' do
    subject { saved_model }

    let(:saved_model) { Valkyrie.config.metadata_adapter.persister.save(resource: model) }
    let(:expected_metadata) { { created_at: saved_model.created_at,
                                id: saved_model.id,
                                internal_resource: 'Schema::Metadata',
                                label: 'abc123_label',
                                new_record: false,
                                updated_at: saved_model.updated_at } }

    it 'has the correct attributes' do
      expect(saved_model.attributes[:core_fields].map(&:id)).to eq(core_fields.map(&:id).map(&:id))
      expect(saved_model.attributes[:fields].map(&:id)).to eq(fields.map(&:id).map(&:id))
      expect(saved_model.attributes).to include(expected_metadata)
    end
  end

  context 'loading template' do
    subject { reloaded_model }

    let(:core_fields) { [create(:schema_metadata_field, label: 'core1')] }
    let(:fields) { [create(:schema_metadata_field, label: 'field1')] }

    let(:saved_model) { Valkyrie.config.metadata_adapter.persister.save(resource: model) }
    let(:reloaded_model) { Schema::Metadata.find(saved_model.id) }

    let(:expected_metadata) { { internal_resource: 'Schema::Metadata',
                                label: 'abc123_label' } }

    its(:attributes) { is_expected.to include(expected_metadata) }

    it 'has core fields' do
      expect(reloaded_model.core_fields.map(&:id)).to eq(core_fields.map(&:id).map(&:id))
    end

    it 'has fields' do
      expect(reloaded_model.fields.map(&:id)).to eq(fields.map(&:id).map(&:id))
    end

    it 'has loaded core fields' do
      expect(reloaded_model.loaded_core_fields.map(&:id)).to eq(core_fields.map(&:id))
      expect(reloaded_model.loaded_core_fields.map(&:label)).to eq(core_fields.map(&:label))
    end

    it 'has loaded fields' do
      expect(reloaded_model.loaded_fields.map(&:id)).to eq(fields.map(&:id))
      expect(reloaded_model.loaded_fields.map(&:label)).to eq(fields.map(&:label))
    end

    it 'loads the fields once' do
      expect(Schema::MetadataField).to receive(:find).with(fields[0].id).once.and_call_original
      reloaded_model.loaded_fields
      reloaded_model.loaded_fields
      reloaded_model.loaded_fields
    end
  end

  describe '#field' do
    subject { model.field('core1') }

    it { is_expected.to eq(core_fields[0]) }

    context 'not a core field' do
      subject { model.field('field1') }

      it { is_expected.to eq(fields[0]) }
    end
  end
end
