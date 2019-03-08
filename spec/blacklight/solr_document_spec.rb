# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument, type: :model do
  subject(:solr_document) { SolrDocument.new(document) }

  before(:all) do
    class MyResource < Valkyrie::Resource
      attribute :alternate_ids, Valkyrie::Types::Array
    end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyResource')
  end

  describe '#internal_resource' do
    let(:document) { { 'internal_resource_tsim' => 'MyResource' } }

    its(:internal_resource) { is_expected.to be(MyResource) }
  end

  describe '#file_sets' do
    subject { solr_document.file_sets.first }

    let(:file_set) { create :file_set }
    let(:document) { { 'internal_resource_tsim' => 'MyResource', member_ids_ssim: [file_set.id.to_s] } }

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
      { 'internal_resource_tsim' => 'MyResource', title_tesim: ['my_title'], created_dtsim: ['2018-04-19T15:46:46Z'] }
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

    it { is_expected.to eq("abc123,my_title,,,,,,,,value1||value2,,xyx789,,\n") }

    context 'with a collection containing works and file sets' do
      let(:collection) { create :library_collection }
      let(:work) { create :work, :with_file, member_of_collection_ids: [collection.id], title: 'Work One' }
      let(:work1_csv) { "#{work.id},Work One,,,,,,,,,,#{collection.id},," }
      let(:file_set1_csv) { "#{work.member_ids.first},hello_world.txt,,,,,,,,,,,," }
      let(:work2) { create :work, :with_file, member_of_collection_ids: [collection.id], title: 'Work Two' }
      let(:work2_csv) { "#{work2.id},Work Two,,,,,,,,,,#{collection.id},," }
      let(:file_set2_csv) { "#{work2.member_ids.first},hello_world.txt,,,,,,,,,,,," }

      let(:csv_header) do
        'id,title,subtitle,description,alternate_ids,creator,audio_field,created,document_field,'\
        'generic_field,map_field,member_of_collection_ids,moving_image_field,still_image_field'
      end

      let(:document) do
        { 'internal_resource_tsim' => 'MyCollection', id: collection.id, title_tesim: ['my_collection'] }
      end

      before do
        work
        work2
      end

      it 'can use multiple pages' do
        expect(solr_document).to receive(:rows).at_least(:once).and_return(1)
        expect(solr_document.export_as_csv).to eq(
          "#{csv_header}\n#{work1_csv}\n#{file_set1_csv}\n#{work2_csv}\n#{file_set2_csv}\n"
        )
      end
    end

    context 'with a work containing file sets' do
      let(:document) do
        {
          'internal_resource_tsim' => 'MyResource',
          id: 'abc123',
          member_of_collection_ids_ssim: ['xyx789'],
          member_ids_ssim: ["id-#{file_set.id}"],
          title_tesim: ['my_title'],
          generic_field_tesim: ['value1', 'value2']
        }
      end

      let(:file_set) { create(:file_set) }
      let(:work_csv) { 'abc123,my_title,,,,,,,,value1||value2,,xyx789,,' }
      let(:file_set_csv) { "#{file_set.id},Original File Name,,,,,,,,,,,," }

      before { file_set }

      it { is_expected.to eq("#{work_csv}\n#{file_set_csv}\n") }
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

  describe '::find' do
    before do
      Valkyrie::MetadataAdapter.find(:index_solr).persister.save(resource: sample_resource)
    end

    context 'with an id' do
      subject { described_class.find('abc1234') }

      let(:sample_resource) { MyResource.new(id: Valkyrie::ID.new('abc1234')) }

      its(:id) { is_expected.to eq('abc1234') }
    end

    context 'with an alternate id' do
      subject { described_class.find('pdq6789') }

      let(:sample_resource) { MyResource.new(id: Valkyrie::ID.new('abc1234'), alternate_ids: ['id-pdq6789']) }

      its(:id) { is_expected.to eq('abc1234') }
    end

    context 'with a non-existent id' do
      let(:sample_resource) { MyResource.new }

      it 'raises an error' do
        expect { described_class.find('nothere') }.to raise_error(Blacklight::Exceptions::RecordNotFound)
      end
    end
  end
end
