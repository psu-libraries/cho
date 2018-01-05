# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing collections', type: :feature do
  let(:resource) { create_for_repository(:collection, title: 'Collection to edit') }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

  before { visit(edit_collection_path(resource)) }

  context 'with all the required metadata' do
    it 'updates an existing collection with new metadata' do
      fill_in('collection[title]', with: 'Updated Work Title')
      click_button('Update Collection to edit')
      expect(page).to have_content('Updated Work Title')
    end
  end

  context 'with a blank title' do
    it 'reports errors' do
      fill_in('collection[title]', with: '')
      click_button('Update Collection to edit')
      expect(page).to have_content("Title can't be blank")
    end
  end

  context 'when deleting a collection' do
    it 'removes the collection from the system' do
      click_link('Delete Collection to edit')
      expect(page).to have_content('Collection to edit has been deleted')
      expect(Collection.count).to eq(0)
      expect(adapter.index_adapter.query_service.find_all.count).to eq(0)
    end
  end
end
