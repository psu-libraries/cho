# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommonQueries do
  before(:all) do
    class CommonResource < Valkyrie::Resource
      include CommonQueries
      attribute :id, Valkyrie::Types::ID.optional
      attribute :label, Valkyrie::Types::String
      attribute :bool_val, Valkyrie::Types::Strict::Bool
    end

    class SampleResource < Valkyrie::Resource
      include CommonQueries
      attribute :id, Valkyrie::Types::ID.optional
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('CommonResource')
    ActiveSupport::Dependencies.remove_constant('SampleResource')
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
        Valkyrie.config.metadata_adapter.persister.save(resource: CommonResource.new(bool_val: false))
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
    let!(:common_resource) do
      Valkyrie.config.metadata_adapter.persister.save(resource: CommonResource.new(bool_val: false))
    end

    before do
      2.times do
        Valkyrie.config.metadata_adapter.persister.save(resource: CommonResource.new(bool_val: false))
      end
    end

    its(:count) { is_expected.to eq(3) }

    describe '::find' do
      subject { CommonResource.find(common_resource.id) }

      its(:id) { is_expected.to eq(common_resource.id) }
    end
  end

  context "with the resource we're looking for" do
    let(:resource1) { CommonResource.new(label: 'first resource', bool_val: false) }
    let(:resource2) { CommonResource.new(label: 'second resource', bool_val: false) }
    let(:resource3) { CommonResource.new(label: 'third resource', bool_val: true) }
    let(:resource4) { CommonResource.new(bool_val: false) }

    it 'retrieves a resource based on its label' do
      persisted_resource = Valkyrie.config.metadata_adapter.persister.save(resource: resource1)
      Valkyrie.config.metadata_adapter.persister.save(resource: resource2)
      results = CommonResource.find_using(label: 'first resource')
      expect(results.count).to eq(1)
      expect(results.first.id).to eq(persisted_resource.id)
    end

    it 'retrieves a resource based on its bool_val' do
      Valkyrie.config.metadata_adapter.persister.save(resource: resource1)
      Valkyrie.config.metadata_adapter.persister.save(resource: resource2)
      persisted_resource = Valkyrie.config.metadata_adapter.persister.save(resource: resource3)
      results = CommonResource.find_using(bool_val: true)
      expect(results.count).to eq(1)
      expect(results.first.id).to eq(persisted_resource.id)
    end

    it 'retrieves a resource based on an empty field' do
      Valkyrie.config.metadata_adapter.persister.save(resource: resource1)
      Valkyrie.config.metadata_adapter.persister.save(resource: resource2)
      persisted_resource = Valkyrie.config.metadata_adapter.persister.save(resource: resource4)
      results = CommonResource.find_using(label: nil)
      expect(results.count).to eq(1)
      expect(results.first.id).to eq(persisted_resource.id)
    end
  end

  describe '::exists?' do
    subject { CommonResource.exists?(id) }

    context 'when the string id does not exist' do
      let(:id) { 'i-dont-exist' }

      it { is_expected.to be_falsey }
    end

    context 'when the Valkyrie::ID does not exist' do
      let(:id) { Valkyrie::ID.new('i-dont-exist') }

      it { is_expected.to be_falsey }
    end

    context 'when the resource does exist' do
      let(:resource) do
        Valkyrie.config.metadata_adapter.persister.save(resource: CommonResource.new(bool_val: true))
      end
      let(:id) { resource.id }

      it { is_expected.to be_truthy }
    end

    context 'when the found resource is a different class' do
      let(:resource) do
        Valkyrie.config.metadata_adapter.persister.save(resource: CommonResource.new(bool_val: true))
      end
      let(:id) { resource.id }

      it 'raises an error' do
        expect { SampleResource.exists?(id) }.to raise_error(
          TypeError, 'Expecting SampleResource, but found CommonResource instead'
        )
      end
    end
  end
end
