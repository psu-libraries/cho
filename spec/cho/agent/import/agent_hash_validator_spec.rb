# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::Import::AgentHashValidator do
  let(:reader) { described_class.new(agent_hash) }

  describe '#change_set' do
    subject(:change_set) { reader.change_set }

    context 'with a new agent' do
      let(:agent_hash) { { 'given_name' => 'Joe', 'surname' => 'Smith' } }

      it 'is valid' do
        expect(change_set).to be_a(Agent::ChangeSet)
        expect(change_set).to be_valid
        expect(change_set.model).to be_a(Agent::Resource)
        expect(change_set.given_name).to eq('Joe')
        expect(change_set.surname).to eq('Smith')
      end
    end

    context 'invalid new agent' do
      let(:agent_hash) { { 'given_name' => '', 'surname' => 'Smith' } }

      it 'is not valid and has errors' do
        expect(change_set).not_to be_valid
        expect(change_set.errors.full_messages).to eq(["Given name can't be blank"])
      end
    end

    context 'with an existing agent' do
      let(:agent) { create(:agent) }

      let(:agent_hash) do
        {
          'id' => agent.id,
          'given_name' => 'Joe',
          'surname' => 'Smith'
        }
      end

      it 'is valid and has an id' do
        expect(change_set).to be_a(Agent::ChangeSet)
        expect(change_set).to be_valid
        expect(change_set.model).to be_a(Agent::Resource)
        expect(change_set.id).to eq(agent.id)
      end
    end

    context 'with a non-existent agent' do
      let(:agent_hash) do
        {
          'id' => 'foo',
          'given_name' => 'Joe',
          'surname' => 'Smith'
        }
      end

      it 'is not valid and has errors' do
        expect(change_set).not_to be_valid
        expect(change_set.errors.full_messages).to eq(['Id does not exist'])
      end
    end
  end
end
