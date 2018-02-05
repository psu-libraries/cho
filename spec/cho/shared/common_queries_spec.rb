# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommonQueries do
  before(:all) do
    class CommonResource < Valkyrie::Resource
      include CommonQueries
      attribute :id, Valkyrie::Types::ID.optional
      attribute :label, Valkyrie::Types::String
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('SpecialModel')
  end

  subject { CommonResource }

  describe '#where' do
    it 'is aliased to #find_using' do
      expect(CommonResource.method(:find_using) == CommonResource.method(:where)).to be(true)
    end
  end

  context 'with no resources present' do
    its(:all)   { is_expected.to be_empty }
    its(:count) { is_expected.to eq(0) }
    its(:last)  { is_expected.to be_nil }
    its(:first) { is_expected.to be_nil }

    describe '::find' do
      subject { CommonResource.find(Valkyrie::ID.new('missing-id')) }

      it { is_expected.to be_nil }
    end
  end

  context 'with existing resources' do
    before do
      3.times do
        Valkyrie.config.metadata_adapter.persister.save(resource: CommonResource.new)
      end
    end

    its(:count) { is_expected.to eq(3) }
    its(:last)  { is_expected.to eq(CommonResource.all.last) }
    its(:first) { is_expected.to eq(CommonResource.all.first) }

    describe '::find' do
      subject { CommonResource.find(Valkyrie::ID.new('missing-id')) }

      it { is_expected.to be_nil }
    end
  end

  context "with the resource we're looking for" do
    let!(:common_resource) { Valkyrie.config.metadata_adapter.persister.save(resource: CommonResource.new) }

    before do
      2.times do
        Valkyrie.config.metadata_adapter.persister.save(resource: CommonResource.new)
      end
    end

    its(:count) { is_expected.to eq(3) }

    describe '::find' do
      subject { CommonResource.find(common_resource.id) }

      its(:id) { is_expected.to eq(common_resource.id) }
    end
  end

  context "with the resource we're looking for" do
    let(:resource1) { CommonResource.new(label: 'first resource') }
    let(:resource2) { CommonResource.new(label: 'second resource') }

    it 'retrieves a resource based on its label' do
      persisted_resource = Valkyrie.config.metadata_adapter.persister.save(resource: resource1)
      Valkyrie.config.metadata_adapter.persister.save(resource: resource2)
      results = CommonResource.find_using(label: 'first resource')
      expect(results.count).to eq(1)
      expect(results.first.id).to eq(persisted_resource.id)
    end
  end
end
