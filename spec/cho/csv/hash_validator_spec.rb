# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Csv::HashValidator, type: :model do
  subject(:change_set) { validator.change_set }

  let(:validator) do
    described_class.new(hash,
      resource_class: SampleResource,
      change_set_class: SampleChangeSet)
  end

  before do
    class SampleResource < Valkyrie::Resource
      include CommonQueries
      attribute :title, Valkyrie::Types::String
    end

    class SampleChangeSet < Valkyrie::ChangeSet
      property :title, required: true
      validates :title, presence: true
    end
  end

  after do
    ActiveSupport::Dependencies.remove_constant('SampleResource')
    ActiveSupport::Dependencies.remove_constant('SampleChangeSet')
  end

  context 'with a new resource' do
    let(:hash) { { 'title' => 'My Great File' } }

    it 'is valid' do
      expect(change_set).to be_a(SampleChangeSet)
      expect(change_set).to be_valid
      expect(change_set.model).to be_a(SampleResource)
      expect(change_set.title).to eq('My Great File')
    end
  end

  context 'with an invalid new resource' do
    let(:hash) { {} }

    it 'is not valid and has errors' do
      expect(change_set).not_to be_valid
      expect(change_set.errors.full_messages).to eq(["Title can't be blank"])
    end
  end

  context 'with an existing resource' do
    let(:resource) do
      Valkyrie::MetadataAdapter.find(:indexing_persister)
        .persister
        .save(resource: SampleResource.new(title: 'Sample Title'))
    end

    let(:hash) { { 'id' => resource.id, 'title' => 'my awesome updated resource' } }

    it 'is valid and has an id' do
      expect(change_set).to be_a(SampleChangeSet)
      expect(change_set).to be_valid
      expect(change_set.model).to be_a(SampleResource)
      expect(change_set.id).to eq(resource.id)
      expect(change_set.title).to eq('my awesome updated resource')
    end
  end

  context 'with a non-existent resource' do
    let(:hash) { { 'id' => 'foo', 'title' => 'my awesome updated resource' } }

    it 'is not valid and has errors' do
      expect(change_set).not_to be_valid
      expect(change_set.title).to eq(['Missing'])
      expect(change_set.errors.full_messages).to eq(['Id does not exist'])
    end
  end
end
