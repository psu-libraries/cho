# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommonQueries do
  before(:all) do
    class CommonResource < Valkyrie::Resource
      include CommonQueries
      attribute :id, Valkyrie::Types::ID.optional
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('SpecialModel')
  end

  subject { CommonResource }

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
end
