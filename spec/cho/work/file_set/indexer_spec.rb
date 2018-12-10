# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::FileSetIndexer do
  let(:file_set) { create(:file_set) }

  let(:indexer) { described_class.new(resource: file_set) }

  describe '#to_solr' do
    context 'with extracted text' do
      let(:extracted_text_file) do
        instance_double(Work::File, path: Pathname.new(fixture_path).join('example_extracted_text.txt'))
      end

      before { allow(file_set).to receive(:text).and_return(extracted_text_file) }

      it 'indexes the extracted text' do
        expect(indexer.to_solr).to include(all_text_timv: "These are the words within the text.\n")
      end
    end

    context 'with a thumbnail' do
      let(:thumbnail_file) do
        instance_double(Work::File, path: Pathname.new(fixture_path).join('thumbnail.png'))
      end

      before { allow(file_set).to receive(:thumbnail).and_return(thumbnail_file) }

      it 'indexes a path to the thumbnail' do
        expect(indexer.to_solr).to include(thumbnail_path_ss: end_with('cho/spec/fixtures/thumbnail.png'))
      end
    end
  end
end
