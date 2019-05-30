# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::AccessControls::AccessLevel do
  let(:resource) { AccessResource.new }
  let(:change_set) { AccessChangeSet.new(resource) }

  before(:all) do
    class AccessResource < Valkyrie::Resource
      include Repository::Access::ResourceControls
      attribute :access_rights
    end

    class AccessChangeSet < Valkyrie::ChangeSet
      include Repository::Access::ChangeSetBehaviors
      property :access_rights
      validates :access_rights, inclusion: { in: Repository::AccessLevel.names }
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('AccessResource')
    ActiveSupport::Dependencies.remove_constant('AccessChangeSet')
  end

  describe '#call' do
    context 'when changing from public default to Penn State' do
      specify do
        expect(change_set.read_groups).to contain_exactly(Repository::AccessLevel.public)
        change_set.access_rights = Repository::AccessLevel.psu
        result = described_class.new.call(change_set)
        expect(result.success.read_groups).to contain_exactly(Repository::AccessLevel.psu)
      end
    end

    context 'when changing from public default to private' do
      specify do
        expect(change_set.read_groups).to contain_exactly(Repository::AccessLevel.public)
        change_set.access_rights = Repository::AccessLevel.restricted
        result = described_class.new.call(change_set)
        expect(result.success.read_groups).to contain_exactly(Repository::AccessLevel.restricted)
      end
    end

    context 'when changing from Penn State to private' do
      before { change_set.read_groups = [Repository::AccessLevel.psu] }

      specify do
        change_set.access_rights = Repository::AccessLevel.restricted
        result = described_class.new.call(change_set)
        expect(result.success.read_groups).to contain_exactly(Repository::AccessLevel.restricted)
      end
    end

    context 'when changing from Penn State to public' do
      before { change_set.read_groups = [Repository::AccessLevel.psu] }

      specify do
        change_set.access_rights = Repository::AccessLevel.public
        result = described_class.new.call(change_set)
        expect(result.success.read_groups).to contain_exactly(Repository::AccessLevel.public)
      end
    end

    context 'when changing from private to Penn State' do
      before { change_set.read_groups = [Repository::AccessLevel.restricted] }

      specify do
        change_set.access_rights = Repository::AccessLevel.psu
        result = described_class.new.call(change_set)
        expect(result.success.read_groups).to contain_exactly(Repository::AccessLevel.psu)
      end
    end

    context 'when changing from private to public' do
      before { change_set.read_groups = [Repository::AccessLevel.restricted] }

      specify do
        change_set.access_rights = Repository::AccessLevel.public
        result = described_class.new.call(change_set)
        expect(result.success.read_groups).to contain_exactly(Repository::AccessLevel.public)
      end
    end

    context 'when changing access levels with other read groups present' do
      before { change_set.read_groups = [Repository::AccessLevel.restricted, 'group1', 'group2'] }

      specify do
        change_set.access_rights = Repository::AccessLevel.psu
        result = described_class.new.call(change_set)
        expect(result.success.read_groups).to contain_exactly(Repository::AccessLevel.psu, 'group1', 'group2')
      end
    end

    context 'when no changes are made' do
      before do
        change_set.access_rights = Repository::AccessLevel.restricted
        change_set.read_groups = [Repository::AccessLevel.restricted]
      end

      specify do
        result = described_class.new.call(change_set)
        expect(result.success.read_groups).to contain_exactly(Repository::AccessLevel.restricted)
        expect(result.success.access_rights).to eq(Repository::AccessLevel.restricted)
      end
    end

    context 'when something unexpected happens' do
      before { allow(change_set).to receive(:access_rights).and_raise(StandardError, 'I fell down') }

      it 'returns a failure' do
        result = described_class.new.call(change_set)
        expect(result).to be_a(Dry::Monads::Result::Failure)
        expect(result.failure.errors.full_messages)
          .to contain_exactly('Transaction Error applying access level: I fell down')
      end
    end
  end
end
