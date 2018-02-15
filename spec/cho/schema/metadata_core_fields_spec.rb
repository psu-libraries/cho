# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schema::MetadataCoreFields, type: :model do
  let(:core_fields) { described_class.generate(Valkyrie.config.metadata_adapter.persister) }

  it 'generates the core fields' do
    expect(core_fields.map(&:label)).to eq(['title', 'subtitle', 'description'])
    expect(core_fields.map(&:order_index).map(&:value)).to eq([0, 1, 2])
  end
end
