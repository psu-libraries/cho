# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe IndexingAdapter do
  let(:adapter) do
    described_class.new(metadata_adapter: Valkyrie::Persistence::Memory::MetadataAdapter.new,
                        index_adapter: index_solr)
  end
  let(:query_service) { adapter.query_service }
  let(:persister)     { adapter.persister }
  let(:index_solr)    { Valkyrie::MetadataAdapter.find(:index_solr) }

  context 'shared examples allowing singular values' do
    it_behaves_like 'a Valkyrie::Persister'
  end

  it 'updates Solr after saving to the metadata adapter' do
    persister.buffer_into_index do |buffered_adapter|
      buffered_adapter.persister.save(resource: build(:work))
    end
    expect(index_solr.query_service.find_all.to_a.length).to eq 1
  end

  it 'does not update Solr until after saving to the metadata adapter' do
    persister.buffer_into_index do |buffered_adapter|
      buffered_adapter.persister.save(resource: build(:work))
      expect(index_solr.query_service.find_all.to_a.length).to eq 0
    end
  end
end
