# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::Shared::ApplyAccessLevel do
  subject(:result) { operation.call(change_set) }

  let(:resource) { AccessResource.new }
  let(:change_set) { AccessChangeSet.new(resource) }
  let(:operation) { described_class.new }

  before(:all) do
    class AccessResource < Valkyrie::Resource
      include Repository::Access::ResourceControls
      attribute :access_level
    end

    class AccessChangeSet < Valkyrie::ChangeSet
      property :access_level
      validates :access_level, inclusion: { in: Repository::AccessLevel.names }
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('AccessResource')
    ActiveSupport::Dependencies.remove_constant('AccessChangeSet')
  end

  describe '#call' do
    context 'with PSU access' do
      before { change_set.access_level = Repository::AccessLevel.psu }

      it 'applies registered read group access' do
        expect(result).to be_a(Dry::Monads::Result::Success)
        expect(result.success.resource.read_groups).to include(Repository::AccessLevel.psu)
      end
    end

    context 'with an unsupported access_level' do
      before { change_set.access_level = 'bogus' }

      it 'returns a failure' do
        expect(result).to be_a(Dry::Monads::Result::Failure)
        expect(result.failure.errors.full_messages).to contain_exactly('Access level is not included in the list')
      end
    end

    context 'when something unexpected happens' do
      before { allow(change_set).to receive(:access_level).and_raise(StandardError, 'I fell down') }

      it 'returns a failure' do
        expect(result).to be_a(Dry::Monads::Result::Failure)
        expect(result.failure.errors.full_messages)
          .to contain_exactly('Transaction Error applying access level: I fell down')
      end
    end
  end
end
