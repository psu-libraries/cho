# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  describe '#admin?' do
    let(:user) { build_stubbed :user }

    it { is_expected.to delegate_method(:admin?).to(:current_user) }
  end

  describe '#admin_permissions' do
    let(:user) { build_stubbed :admin }

    it { is_expected.to be_able_to(:manage, :all) }
  end

  describe '#cannot_delete_agent_with_members' do
    let(:user) { build_stubbed :admin }

    context 'given an agent with no members' do
      let(:agent) { create :agent }

      before { raise 'sanity' if agent.member_ids.any? }

      it { is_expected.to be_able_to(:delete, agent) }
    end

    context 'given an agent with members' do
      let(:work) { create :work, :with_creator }
      let(:agent) { Agent::Resource.find(work.creator.first.fetch(:agent)) }

      before { raise 'sanity' if agent.member_ids.empty? }

      it { is_expected.not_to be_able_to(:delete, agent) }
    end
  end

  describe '#base_permissions' do
    let(:user) { nil }

    it { is_expected.to be_able_to(:manage, :bookmark) }
    it { is_expected.to be_able_to(:manage, :devise_remote) }
    it { is_expected.to be_able_to(:manage, :search_history) }
    it { is_expected.to be_able_to(:manage, :session) }
  end
end
