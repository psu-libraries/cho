# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transaction::Operations::File::Create do
  let(:operation) { described_class.new }

  describe '#call' do
    subject(:result) { operation.call(change_set, temp_file: file) }

    let(:file_set) { create :file_set }
    let(:work_file) {}
    let(:change_set) { Work::FileChangeSet.new(Work::File.new(original_filename: 'my_file.txt')) }
    let(:file) do
      temp_file = Tempfile.new('hello')
      temp_file.write(File.open(Rails.root.join('spec', 'fixtures', 'hello_world.txt')).read)
      temp_file.rewind
      temp_file
    end

    it 'returns Success' do
      expect {
        expect(result).to be_success
        expect(result.success.class).to eq(Work::FileChangeSet)
        expect(result.success.original_filename).to eq('my_file.txt')
      }.to change { Work::File.count }.by(1)
    end

    context 'bad file' do
      let(:file) { nil }

      it 'returns Failure' do
        expect(result).to be_failure
        expect(result.failure.message).to eq('Error persisting file: undefined method `path\' for nil:NilClass')
      end
    end
  end
end
