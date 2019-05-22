# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::AccessControls::Permissions do
  before(:all) do
    class PermissionsResource < Valkyrie::Resource
      include Repository::Access::ResourceControls
    end

    class PermissionsChangeSet < Valkyrie::ChangeSet
      include Repository::Access::ChangeSetBehaviors
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('PermissionsResource')
    ActiveSupport::Dependencies.remove_constant('PermissionsChangeSet')
  end

  describe '#call' do
    context 'when access controls do not govern the change set' do
      subject { described_class.new.call(change_set) }

      let(:change_set) { instance_double(Valkyrie::ChangeSet) }

      it { is_expected.to be_success }
    end

    context 'when the system creator is not a read user' do
      let(:change_set) { PermissionsChangeSet.new(PermissionsResource.new(system_creator: 'original_user')) }

      specify do
        expect(change_set.system_creator).to eq('original_user')
        expect(change_set.read_users).to be_empty
        result = described_class.new.call(change_set)
        expect(result).to be_success
        expect(change_set.read_users).to contain_exactly('original_user')
      end
    end

    context 'when other users are present' do
      let(:change_set) do
        PermissionsChangeSet.new(
          PermissionsResource.new(system_creator: 'original_user', read_users: ['another_user'])
        )
      end

      specify do
        expect(change_set.system_creator).to eq('original_user')
        expect(change_set.read_users).to contain_exactly('another_user')
        result = described_class.new.call(change_set)
        expect(result).to be_success
        expect(change_set.read_users).to contain_exactly('original_user', 'another_user')
      end
    end

    context 'when something unexpected happens' do
      let(:change_set) { instance_double(Valkyrie::ChangeSet) }

      before { allow(change_set).to receive(:class).and_raise(StandardError, 'I fell down') }

      specify do
        result = described_class.new.call(change_set)
        expect(result).to be_a(Dry::Monads::Result::Failure)
        expect(result.failure.errors.full_messages)
          .to contain_exactly('Transaction Error applying permissions: I fell down')
      end
    end
  end
end
