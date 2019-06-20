# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::RepresentativeImagePresenter do
  subject(:presenter) { described_class.new(document) }

  let(:document) { instance_spy 'SolrDocument', alternate_ids_data_dictionary_field: [collection_id] }
  let(:collection_id) { 'id-abc123' }

  let(:base_url) { Cho::Application.config.collection_image_directory.relative_path_from(Rails.root.join('public')) }

  describe '#basename' do
    subject { presenter.basename }

    context 'when id is prefixed' do
      let(:collection_id) { 'id-abc123' }

      it { is_expected.to eq 'abc123' }
    end

    context 'when id is not prefixed' do
      let(:collection_id) { 'abc123' }

      it { is_expected.to eq 'abc123' }
    end

    context 'when id is UPPERCASED' do
      let(:collection_id) { 'ABC123' }

      it { is_expected.to eq 'abc123' }
    end

    context 'when id is missing' do
      let(:collection_id) { nil }

      it { is_expected.to be_nil }
    end
  end

  %w[jpg jpeg png gif].each do |format|
    context "when an image exists in #{format} format" do
      let(:collection_id) { "test__#{Time.now.strftime('%Y-%m-%d__%H-%M-%S')}" }
      let(:file_path) { Cho::Application.config.collection_image_directory.join("#{collection_id}.#{format}") }

      before { FileUtils.touch(file_path) }

      after { FileUtils.rm(file_path) }

      its(:exists?) { is_expected.to be true }
      its(:identifier) { is_expected.to eq "#{collection_id}.#{format}" }
      its(:path) { is_expected.to eq "/#{base_url}/#{collection_id}.#{format}" }
    end
  end

  context 'when no image exists in the directory' do
    let(:collection_id) { 'does-not-exist' }

    its(:exists?) { is_expected.to be false }
    its(:identifier) { is_expected.to be_nil }
    its(:path) { is_expected.to eq '/default-collection-image.png' }
  end
end
