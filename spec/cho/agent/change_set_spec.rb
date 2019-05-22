# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Agent::ChangeSet, type: :model do
  subject(:change_set) { described_class.new(Agent::Resource.new) }

  it { is_expected.to delegate_method(:member_ids).to(:resource) }

  describe '#validate' do
    context 'when given name is missing' do
      subject { change_set.errors }

      let(:params) { { surname: 'Jones' } }

      before { change_set.validate(surname: 'Jones') }

      its(:full_messages) { is_expected.to include("Given name can't be blank") }
    end

    context 'when surname name is missing' do
      subject { change_set.errors }

      before { change_set.validate(given_name: 'Jessica') }

      its(:full_messages) { is_expected.to include("Surname can't be blank") }
    end

    context 'when an agent with the same name already exists' do
      subject { change_set.errors }

      before do
        create(:agent, given_name: 'Zebediah', surname: 'Killgrave')
        change_set.validate(given_name: 'Zebediah', surname: 'Killgrave')
      end

      its(:full_messages) { is_expected.to include('Zebediah Killgrave already exists') }
    end

    context 'when updating an existing agent' do
      let(:agent) { create(:agent, given_name: 'Thomas', surname: 'Anderson') }

      before { create(:agent, given_name: 'Zebediah', surname: 'Killgrave') }

      it 'does not allow duplicates' do
        change_set = described_class.new(agent)
        expect(change_set).to be_valid
        change_set.validate(given_name: 'Zebediah', surname: 'Killgrave')
        expect(change_set).not_to be_valid
      end
    end
  end
end
