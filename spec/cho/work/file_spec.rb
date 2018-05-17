# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Work::File do
  let(:resource_klass) { described_class }
  let(:file) { described_class.new }
  let(:binary_content) do
    Valkyrie.config.storage_adapter.upload(file: temp_file, original_filename: 'My File.txt', resource: file)
  end
  let(:temp_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt')) }

  it_behaves_like 'a Valkyrie::Resource'

  it 'can have a file attached' do
    file.file_identifier = binary_content.id
    saved_resource = Valkyrie.config.metadata_adapter.persister.save(resource: file)
    expect(saved_resource.file_identifier).to eq(binary_content.id)
  end

  describe '#path' do
    subject { file }

    context 'when no file is present' do
      its(:path) { is_expected.to be_nil }
    end

    context 'with a file' do
      before { file.file_identifier = binary_content.id }
      its(:path) { is_expected.to end_with('cho/tmp/files/My File.txt') }
    end
  end
end
