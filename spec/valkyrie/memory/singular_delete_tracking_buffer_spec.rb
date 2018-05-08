# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Memory::SingularDeleteTrackingBuffer do
  let(:adapter) { described_class.new }
  let(:query_service) { adapter.query_service }
  let(:persister) do
    adapter.persister
  end

  context 'shared examples allowing singular values' do
    before do |example|
      # We are skipping the check for 'does not save non-array properties' since we are allowing sigular values
      if example.description == 'does not save non-array properties'
        skip 'We are allowing Non Array Properties'
      end
    end

    it_behaves_like 'a Valkyrie::Persister'
  end
  before do
    class Resource < Valkyrie::Resource
      include Valkyrie::Resource::AccessControls
      attribute :id, Valkyrie::Types::ID.optional
      attribute :title
      attribute :member_ids
      attribute :nested_resource
    end
  end
  after do
    Object.send(:remove_const, :Resource)
  end
  it 'tracks deletes' do
    obj = persister.save(resource: Resource.new)
    persister.delete(resource: obj)

    expect(persister.deletes).to eq [obj]
  end
end
