# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument, type: :model do
  before(:all) do
    class MyResource; end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyResource')
  end

  describe '#internal_resource' do
    subject { SolrDocument.new(document) }

    let(:document) { { 'internal_resource_tsim' => 'MyResource' } }

    its(:internal_resource) { is_expected.to be(MyResource) }
  end

  describe '#files' do
    subject { SolrDocument.new(document).files.first }

    let(:work_file) { create :work_file }
    let(:document) { { 'internal_resource_tsim' => 'MyResource', files_ssim: [work_file.id.to_s] } }

    its(:to_h) { is_expected.to include(original_filename: 'original_name',
                                        internal_resource: 'Work::File',
                                        id: Valkyrie::ID.new(work_file.id)) }
  end

  describe '#member_of_collections' do
    subject { SolrDocument.new(document).member_of_collections.first }

    let(:collection) { create(:archival_collection) }
    let(:document) { { 'internal_resource_tsim' => 'MyResource', member_of_collection_ids_ssim: [collection.id.to_s] } }

    its(:to_h) { is_expected.to include('title_tesim' => ['Archival Collection'],
                                        'internal_resource_tesim' => ['Collection::Archival'],
                                        'id' => collection.id.to_s) }
  end
end
