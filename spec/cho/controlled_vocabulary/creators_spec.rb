# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ControlledVocabulary::Creators, type: :model do
  describe '#list' do
    context 'with agents' do
      subject { described_class.list(component: :agents).map(&:id) }

      let!(:agent1) { create(:agent) }
      let!(:agent2) { create(:agent, given_name: 'Jim', surname: 'Bob') }

      it { is_expected.to contain_exactly(agent1.id, agent2.id) }
    end

    context 'with roles' do
      subject { described_class.list(component: :roles) }

      it { is_expected.to eq(MockRDF.relators) }
    end

    context 'with a bogus component' do
      it 'raises an error' do
        expect { described_class.list(component: :bad) }.to raise_error(
          ControlledVocabulary::Creators::UnsupportedComponentError,
          'bad is not a supported component of ControlledVocabulary::Creators. Only :agents and :roles are allowed.'
        )
      end
    end
  end
end
