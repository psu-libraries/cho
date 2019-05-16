# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  describe '#admin_permissions' do
    let(:user) { build_stubbed :admin }

    it { is_expected.to be_able_to(:manage, :all) }
  end

  describe '#authenticated_permissions' do
    let(:user) { build_stubbed :psu_user }

    it { is_expected.to be_able_to(:read, :all) }
  end

  describe '#base_permissions' do
    let(:user) { nil }

    it { is_expected.to be_able_to(:manage, :bookmark) }
    it { is_expected.to be_able_to(:manage, :devise_remote) }
    it { is_expected.to be_able_to(:manage, :search_history) }
    it { is_expected.to be_able_to(:manage, :session) }
  end
end
