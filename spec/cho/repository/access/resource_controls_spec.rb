# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Access::ResourceControls do
  before(:all) do
    class ControlledResource < Valkyrie::Resource
      include Repository::Access::ResourceControls
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('ControlledResource')
  end

  let(:resource_klass) { ControlledResource }

  describe '#has_attribute?' do
    subject(:resource) { resource_klass.new }

    specify do
      expect(resource.has_attribute?(:discover_groups)).to eq true
      expect(resource.has_attribute?(:discover_users)).to eq true
      expect(resource.has_attribute?(:read_groups)).to eq true
      expect(resource.has_attribute?(:read_users)).to eq true
      expect(resource.has_attribute?(:download_groups)).to eq true
      expect(resource.has_attribute?(:download_users)).to eq true
      expect(resource.has_attribute?(:edit_groups)).to eq true
      expect(resource.has_attribute?(:edit_users)).to eq true
      expect(resource.has_attribute?(:system_creator)).to eq true
    end
  end

  describe '#fields' do
    it 'returns a set of fields' do
      expect(resource_klass).to respond_to(:fields).with(0).arguments
      expect(resource_klass.fields).to include(
        :discover_users,
        :discover_groups,
        :read_users,
        :read_groups,
        :download_users,
        :download_groups,
        :edit_users,
        :edit_groups,
        :system_creator
      )
    end
  end

  describe '#discover_users' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(discover_users: ['one', 'two'])
      expect(resource.discover_users).to eq ['one', 'two']
      expect(resource.attributes[:discover_users]).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.discover_users).to be_empty
    end
  end

  describe '#discover_groups' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(discover_groups: ['one', 'two'])
      expect(resource.discover_groups).to eq ['one', 'two']
      expect(resource.attributes[:discover_groups]).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.discover_groups).to be_empty
    end
  end

  describe '#read_users' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(read_users: ['one', 'two'])
      expect(resource.read_users).to eq ['one', 'two']
      expect(resource.attributes[:read_users]).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.read_users).to be_empty
    end
  end

  describe '#read_groups' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(read_groups: ['one', 'two'])
      expect(resource.read_groups).to eq ['one', 'two']
      expect(resource.attributes[:read_groups]).to eq ['one', 'two']
    end

    it 'is public when not set' do
      resource = resource_klass.new
      expect(resource.read_groups).to contain_exactly(Repository::AccessLevel.public)
    end
  end

  describe '#download_users' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(download_users: ['one', 'two'])
      expect(resource.download_users).to eq ['one', 'two']
      expect(resource.attributes[:download_users]).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.download_users).to be_empty
    end
  end

  describe '#download_groups' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(download_groups: ['one', 'two'])
      expect(resource.download_groups).to eq ['one', 'two']
      expect(resource.attributes[:download_groups]).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.download_groups).to be_empty
    end
  end

  describe '#edit_users' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(edit_users: ['one', 'two'])
      expect(resource.edit_users).to eq ['one', 'two']
      expect(resource.attributes[:edit_users]).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.edit_users).to be_empty
    end
  end

  describe '#edit_groups' do
    it 'can be set via instantiation' do
      resource = resource_klass.new(edit_groups: ['one', 'two'])
      expect(resource.edit_groups).to eq ['one', 'two']
      expect(resource.attributes[:edit_groups]).to eq ['one', 'two']
    end

    it 'is empty when not set' do
      resource = resource_klass.new
      expect(resource.edit_groups).to be_empty
    end
  end

  describe '#system_creator' do
    it 'defaults to the default system user' do
      resource = resource_klass.new
      expect(resource.system_creator).to eq(Repository::Access::ResourceControls::DEFAULT_SYSTEM_USER)
    end
  end
end
