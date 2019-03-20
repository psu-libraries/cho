# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  context 'with an admin user' do
    let(:user) { build_stubbed :admin }

    it { is_expected.to be_able_to(:manage, :all) }
  end

  context 'with a psu user' do
    let(:user) { build_stubbed :psu_user }

    it { is_expected.to be_able_to(:read, :all) }
    it { is_expected.to be_able_to(:manage, :bookmark) }
    it { is_expected.to be_able_to(:manage, :catalog) }
    it { is_expected.to be_able_to(:manage, :download) }
    it { is_expected.to be_able_to(:manage, :search_history) }
    it { is_expected.not_to be_able_to(:manage, :all) }
  end

  context 'with a public user' do
    let(:user) { nil }

    it { is_expected.to be_able_to(:read, :all) }
    it { is_expected.to be_able_to(:manage, :bookmark) }
    it { is_expected.to be_able_to(:manage, :catalog) }
    it { is_expected.to be_able_to(:manage, :download) }
    it { is_expected.to be_able_to(:manage, :search_history) }
    it { is_expected.not_to be_able_to(:manage, :all) }
  end
end
