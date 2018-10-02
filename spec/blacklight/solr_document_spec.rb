# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument, type: :model do
  before(:all) do
    class MyResource; end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyResource')
  end

  subject(:solr_document) { SolrDocument.new(document) }

  describe '#internal_resource' do
    let(:document) { { 'internal_resource_tsim' => 'MyResource' } }

    its(:internal_resource) { is_expected.to be(MyResource) }
  end

  describe '#file_sets' do
    subject { solr_document.file_sets.first }

    let(:file_set) { create :file_set }
    let(:document) { { 'internal_resource_tsim' => 'MyResource', file_set_ids_ssim: [file_set.id.to_s] } }

    its(:to_h) { is_expected.to include(title: ['Original File Name'],
                                        internal_resource: 'Work::FileSet',
                                        id: Valkyrie::ID.new(file_set.id)) }
  end

  describe '#member_of_collections' do
    subject { solr_document.member_of_collections.first }

    let(:collection) { create(:archival_collection) }

    let(:document) do
      { 'internal_resource_tsim' => 'MyResource', member_of_collection_ids_ssim: [collection.id.to_s] }
    end

    its(:to_h) { is_expected.to include('title_tesim' => ['Archival Collection'],
                                        'internal_resource_tesim' => ['Collection::Archival'],
                                        'id' => collection.id.to_s) }
  end

  describe 'data dictionary field accessors' do
    let(:document) do
      { 'internal_resource_tsim' => 'MyResource', title_tesim: ['my_title'], created_dtsi: ['2018-04-19T15:46:46Z'] }
    end

    its(:title_data_dictionary_field) { is_expected.to eq ['my_title'] }
    its(:created_data_dictionary_field) { is_expected.to eq ['2018-04-19T15:46:46Z'] }
  end

  describe 'exports_as? csv' do
    subject { solr_document.exports_as?(:csv) }

    let(:document) { { 'internal_resource_tsim' => 'MyResource' } }

    it { is_expected.to be_truthy }
  end

  describe 'export_as_csv' do
    subject { solr_document.export_as_csv }

    let(:document) do
      {
        'internal_resource_tsim' => 'MyResource',
        id: 'abc123',
        member_of_collection_ids_ssim: ['xyx789'],
        title_tesim: ['my_title'],
        generic_field_tesim: ['value1', 'value2']
      }
    end

    it { is_expected.to eq("abc123,my_title,,,,,,,value1|value2,,xyx789,,\n") }

    context 'a collection' do
      let(:collection) { create :library_collection }
      let(:work) { create :work, member_of_collection_ids: [collection.id], title: 'Work One' }
      let(:work1_csv) { "#{work.id},Work One,,,,,,,,,#{collection.id},," }
      let(:work2) { create :work, member_of_collection_ids: [collection.id], title: 'Work Two' }
      let(:work2_csv) { "#{work2.id},Work Two,,,,,,,,,#{collection.id},," }

      let(:csv_header) do
        'id,title,subtitle,description,identifier,audio_field,created,document_field,'\
        'generic_field,map_field,member_of_collection_ids,moving_image_field,still_image_field'
      end

      let(:document) do
        { 'internal_resource_tsim' => 'MyCollection', id: collection.id, title_tesim: ['my_collection'] }
      end

      before do
        work
        work2
      end

      it { is_expected.to eq("#{csv_header}\n#{work1_csv}\n#{work2_csv}\n") }

      it 'can use multiple pages' do
        expect(solr_document).to receive(:rows).at_least(:once).and_return(1)
        expect(solr_document.export_as_csv).to eq("#{csv_header}\n#{work1_csv}\n#{work2_csv}\n")
      end
    end
  end

  describe 'is_collection?' do
    subject { solr_document.collection? }

    let(:document) { { 'internal_resource_tsim' => 'MyResource' } }

    it { is_expected.to be_falsey }

    context 'collection document' do
      let(:document) { { 'internal_resource_tsim' => 'MyCollection' } }

      it { is_expected.to be_truthy }
    end
  end

  describe '#schema' do
    subject { solr_document.schema }

    let(:document) { { 'internal_resource_tsim' => 'Work::Submission', work_type_ssim: ['Document'] } }

    its(:label) { is_expected.to eq('Document') }

    context 'for a collection' do
      let(:document) { { 'internal_resource_tsim' => 'ArchivalCollection' } }

      its(:label) { is_expected.to eq('Collection') }
    end
  end
end
