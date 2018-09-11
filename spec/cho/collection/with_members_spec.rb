# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::WithMembers do
  before(:all) do
    class ParentResource < Valkyrie::Resource
      include Collection::WithMembers

      attribute :id, Valkyrie::Types::ID.optional
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('ParentResource')
  end

  describe '#members' do
    context 'when an association exists' do
      it 'returns the members associated with the resource' do
        change_set = Valkyrie::ChangeSet.new(ParentResource.new)
        parent = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: change_set.resource)
        member = create(:work, member_of_collection_ids: [parent.id])
        reloaded_parent = Valkyrie.config.metadata_adapter.query_service.find_by(id: parent.id)
        expect(reloaded_parent.members.map(&:id)).to contain_exactly(member.id)
      end
    end

    context 'when no association exists' do
      it 'returns an empty array' do
        change_set = Valkyrie::ChangeSet.new(ParentResource.new)
        parent = Valkyrie.config.metadata_adapter.persister.save(resource: change_set.resource)
        reloaded_parent = Valkyrie.config.metadata_adapter.query_service.find_by(id: parent.id)
        expect(reloaded_parent.members).to be_empty
      end
    end
  end
end
