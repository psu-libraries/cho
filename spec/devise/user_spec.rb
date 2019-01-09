# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe '#populate_attributes' do
    before do
      allow(PsuDir::LdapUser).to receive(:get_groups).with(user.login).and_return(groups)
    end

    context 'when the user has groups' do
      let(:groups) { ['umg/group.one', 'umg/group.two'] }

      it 'updates the user with their LDAP groups' do
        expect(user.group_list).to be_empty
        expect(user.groups_last_update).to be_nil
        user.populate_attributes
        expect(user.group_list).to eq('umg/group.one;?;umg/group.two')
        expect(user.groups_last_update).not_to be_nil
      end
    end

    context 'when the user has no groups' do
      let(:groups) { [] }

      it 'does not update the user' do
        expect(user.populate_attributes).to be_nil
      end
    end
  end

  describe '#groups' do
    context "when the user's groups are up-to-date" do
      let(:user) { create(:user, group_list: 'group1;?;group2', groups_last_update: Time.now) }

      it 'returns a list of groups from the database' do
        expect(user).not_to receive(:populate_attributes)
        expect(user.groups).to contain_exactly('group1', 'group2')
      end
    end

    context "when the user hasn't updated their groups" do
      let(:user) { create(:user) }
      let(:groups) { ['group1', 'group2'] }

      it 'returns a list of groups from the database' do
        expect(PsuDir::LdapUser).to receive(:get_groups).with(user.login).and_return(groups)
        expect(user.groups).to contain_exactly('group1', 'group2')
      end
    end

    context "when the user hasn't updated their groups in over 24 hours" do
      let(:user) { create(:user, groups_last_update: (Time.now - 48.hours)) }
      let(:groups) { ['group1', 'group2'] }

      it 'returns a list of groups from the database' do
        expect(PsuDir::LdapUser).to receive(:get_groups).with(user.login).and_return(groups)
        expect(user.groups).to contain_exactly('group1', 'group2')
      end
    end
  end

  describe 'admin?' do
    subject { user.admin? }

    context 'with a non-admin user' do
      before { allow(user).to receive(:groups).and_return([]) }

      it { is_expected.to be_falsey }
    end

    context 'with an admin user' do
      before { allow(user).to receive(:groups).and_return(['group1', 'umg/up.libraries.cho-admin']) }

      it { is_expected.to be_truthy }
    end
  end
end
