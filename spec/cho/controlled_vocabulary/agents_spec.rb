# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::Agents, type: :model do
  describe '#list' do
    subject { described_class.list.map(&:id) }

    context 'with agents' do
      let!(:agent1) { create(:agent) }
      let!(:agent2) { create(:agent, given_name: 'Jim', surname: 'Bob') }

      it { is_expected.to contain_exactly(agent1.id, agent2.id) }
    end

    context 'with no agents' do
      it { is_expected.to be_empty }
    end
  end
end
