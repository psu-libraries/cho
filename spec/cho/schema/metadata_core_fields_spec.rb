# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schema::MetadataCoreFields, type: :model do
  let(:core_fields) { described_class.generate(Valkyrie.config.metadata_adapter.persister) }
  let(:title_field) { Schema::MetadataField.where(label: 'title').first }

  it 'generates the core fields' do
    expect(core_fields.map(&:label)).to eq(['title', 'subtitle', 'description'])
    expect(core_fields.map(&:order_index)).to eq([0, 1, 2])
  end

  it 'saves the core fields' do
    saved_core_fields = core_fields.map { |field| Schema::MetadataField.find(field.id) }
    expect(saved_core_fields.map(&:order_index)).to eq([0, 1, 2])
  end
end
