# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::AccessControls::SystemCreator do
  before(:all) do
    class SystemCreatorResource < Valkyrie::Resource
      include Repository::Access::ResourceControls
    end

    class SystemCreatorChangeSet < Valkyrie::ChangeSet
      include Repository::Access::ChangeSetBehaviors
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('SystemCreatorResource')
    ActiveSupport::Dependencies.remove_constant('SystemCreatorChangeSet')
  end

  describe '#call' do
    context 'with a persisted change set' do
      let(:change_set) { SystemCreatorChangeSet.new(SystemCreatorResource.new(system_creator: 'original_user')) }

      before { allow(change_set).to receive(:persisted?).and_return(true) }

      it 'does not change the system creator' do
        expect(change_set.system_creator).to eq('original_user')
        result = described_class.new.call(change_set)
        expect(result).to be_success
        expect(result.success.system_creator).to eq('original_user')
      end
    end

    context 'with an un-persisted change set' do
      before { allow(change_set).to receive(:persisted?).and_return(false) }

      context 'without a current user' do
        subject(:result) { described_class.new.call(change_set) }

        let(:change_set) { instance_double(Valkyrie::ChangeSet) }

        it { is_expected.to be_success }
      end

      context 'with a current user' do
        let(:change_set) { SystemCreatorChangeSet.new(SystemCreatorResource.new) }
        let(:user) { build(:user) }

        before { change_set.current_user = user }

        it 'updates the system creator' do
          expect(change_set.system_creator).to eq(Repository::Access::ResourceControls::DEFAULT_SYSTEM_USER)
          result = described_class.new.call(change_set)
          expect(result).to be_success
          expect(result.success.system_creator).to eq(user.login)
        end
      end
    end

    context 'when something unexpected happens' do
      let(:change_set) { instance_double(Valkyrie::ChangeSet) }

      before { allow(change_set).to receive(:persisted?).and_raise(StandardError, 'I fell down') }

      it 'returns a failure' do
        result = described_class.new.call(change_set)
        expect(result).to be_a(Dry::Monads::Result::Failure)
        expect(result.failure.errors.full_messages)
          .to contain_exactly('Transaction Error applying system creator: I fell down')
      end
    end
  end
end
