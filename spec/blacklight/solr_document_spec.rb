# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SolrDocument, type: :model do
  before(:all) do
    class MyResource; end
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyResource')
  end

  subject { SolrDocument.new(document) }

  let(:document) { { 'internal_resource_tsim' => 'MyResource' } }

  describe '#internal_resource' do
    its(:internal_resource) { is_expected.to be(MyResource) }
  end

  describe '#files' do
    subject { SolrDocument.new(document).files.first }

    let(:work_file) { create_for_repository :work_file }
    let(:document) { { 'internal_resource_tsim' => 'MyResource', files_ssim: [work_file.id.to_s] } }

    its(:to_h) { is_expected.to include(original_filename: 'original_name', internal_resource: 'Work::File', id: work_file.id) }
  end
end
