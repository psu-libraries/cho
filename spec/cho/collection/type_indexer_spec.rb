# frozen_string_literal: true

require 'rails_helper'

describe Collection::TypeIndexer do
  let(:indexer) { described_class.new(resource: resource) }

  describe '#to_solr' do
    subject { indexer.to_solr }

    context 'with an archival collection' do
      let(:resource) { Collection::Archival.new }

      it { is_expected.to eq(collection_type_ssim: 'Archival Collection') }
    end

    context 'with a library collection' do
      let(:resource) { Collection::Library.new }

      it { is_expected.to eq(collection_type_ssim: 'Library Collection') }
    end

    context 'with a curated collection' do
      let(:resource) { Collection::Curated.new }

      it { is_expected.to eq(collection_type_ssim: 'Curated Collection') }
    end

    context 'with a submission' do
      let(:resource) { Work::Submission.new }

      it { is_expected.to be_empty }
    end
  end
end
