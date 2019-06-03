# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schema::MetadataCoreFields, type: :model do
  let(:core_fields) { described_class.generate(Valkyrie.config.metadata_adapter, work_type: 'Document') }
  let(:title_field) { Schema::MetadataField.where(label: 'title').first }

  it 'generates the core fields' do
    expect(core_fields.map(&:label)).to eq(['title',
                                            'subtitle',
                                            'description',
                                            'alternate_ids',
                                            'creator',
                                            'date_cataloged'])
    expect(core_fields.map(&:order_index)).to eq([0, 1, 2, 3, 4, 5])
  end

  it 'saves the core fields' do
    saved_core_fields = core_fields.map { |field| Schema::MetadataField.find(field.id) }
    expect(saved_core_fields.map(&:order_index)).to eq([0, 1, 2, 3, 4, 5])
  end

  context 'multiple work types' do
    let(:generic_core_fields) { described_class.generate(Valkyrie.config.metadata_adapter, work_type: 'Generic') }
    let(:document_core_fields) { described_class.generate(Valkyrie.config.metadata_adapter, work_type: 'Document') }

    it 'saves different core fields based on type' do
      core_field_ids = generic_core_fields.map(&:id) + document_core_fields.map(&:id)
      expect(core_field_ids.uniq.count).to eq(12)
    end
  end
end
