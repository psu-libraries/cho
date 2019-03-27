# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch::DeletePresenter, type: :model do
  describe '#id' do
    subject(:presenter) { Batch::DeletePresenter.new(double) }

    it { is_expected.to delegate_method(:id).to(:resource) }
  end

  describe '#confirmation_title' do
    subject(:presenter) { Batch::DeletePresenter.new(work) }

    let(:work) { build(:work) }

    its(:confirmation_title) { is_expected.to eq('Sample Generic Work (0)') }
  end

  describe '#children' do
    let(:work) { create(:work, :with_file) }

    context 'with an empty collection' do
      subject(:presenter) { Batch::DeletePresenter.new(create(:collection)) }

      its(:children) { is_expected.to be_empty }
    end

    context 'with a collection containing works with files' do
      it 'lists all works, file sets, and files' do
        collection = Collection::Archival.find(work.home_collection_id)
        presenter = Batch::DeletePresenter.new(collection)
        expect(presenter.children).to contain_exactly(
          'Work: Sample Generic Work',
          'File set: hello_world.txt',
          'File: hello_world.txt'
        )
      end
    end

    context 'with a work with no files' do
      subject(:presenter) { Batch::DeletePresenter.new(create(:work)) }

      its(:children) { is_expected.to be_empty }
    end

    context 'with a works containing files' do
      it 'lists file sets and files' do
        presenter = Batch::DeletePresenter.new(work)
        expect(presenter.children).to contain_exactly(
          'File set: hello_world.txt',
          'File: hello_world.txt'
        )
      end
    end

    context 'with file sets containing files' do
      it 'lists the files' do
        presenter = Batch::DeletePresenter.new(work.file_sets.first)
        expect(presenter.children).to contain_exactly(
          'File: hello_world.txt'
        )
      end
    end
  end
end
