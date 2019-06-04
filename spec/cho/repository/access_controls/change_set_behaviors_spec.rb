# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::AccessControls::ChangeSetBehaviors do
  subject(:change_set) { ControlledChangeSet.new(ControlledResource.new) }

  before(:all) do
    class ControlledResource < Valkyrie::Resource
      include Repository::AccessControls::Fields
    end

    class ControlledChangeSet < Valkyrie::ChangeSet
      include Repository::AccessControls::ChangeSetBehaviors
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('ControlledResource')
    ActiveSupport::Dependencies.remove_constant('ControlledChangeSet')
  end

  describe '#system_creator' do
    its(:system_creator) { is_expected.to be(Repository::AccessControls::Fields::DEFAULT_SYSTEM_USER) }

    it { is_expected.to be_required(:system_creator) }
    it { is_expected.not_to be_multiple(:system_creator) }
  end

  describe '#current_user' do
    its(:current_user) { is_expected.to be_nil }

    it { is_expected.not_to be_required(:current_user) }
    it { is_expected.not_to be_multiple(:current_user) }
  end

  describe '#discover_users' do
    its(:discover_users) { is_expected.to be_empty }

    it { is_expected.not_to be_required(:discover_users) }
    it { is_expected.to be_multiple(:discover_users) }
  end

  describe '#discover_groups' do
    its(:discover_groups) { is_expected.to be_empty }

    it { is_expected.not_to be_required(:discover_groups) }
    it { is_expected.to be_multiple(:discover_groups) }
  end

  describe '#read_users' do
    its(:read_users) { is_expected.to be_empty }

    it { is_expected.not_to be_required(:read_users) }
    it { is_expected.to be_multiple(:read_users) }
  end

  describe '#read_groups' do
    its(:read_groups) { is_expected.to contain_exactly(Repository::AccessControls::AccessLevel.public) }

    it { is_expected.not_to be_required(:read_groups) }
    it { is_expected.to be_multiple(:read_groups) }
  end

  describe '#download_users' do
    its(:download_users) { is_expected.to be_empty }

    it { is_expected.not_to be_required(:download_users) }
    it { is_expected.to be_multiple(:download_users) }
  end

  describe '#download_groups' do
    its(:download_groups) { is_expected.to be_empty }

    it { is_expected.not_to be_required(:download_groups) }
    it { is_expected.to be_multiple(:download_groups) }
  end

  describe '#edit_users' do
    its(:edit_users) { is_expected.to be_empty }

    it { is_expected.not_to be_required(:edit_users) }
    it { is_expected.to be_multiple(:edit_users) }
  end

  describe '#edit_groups' do
    its(:edit_groups) { is_expected.to be_empty }

    it { is_expected.not_to be_required(:edit_groups) }
    it { is_expected.to be_multiple(:edit_groups) }
  end
end
