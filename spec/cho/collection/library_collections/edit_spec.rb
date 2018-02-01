# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Library, type: :feature do
  let(:resource) { create_for_repository(:library_collection, title: 'Library collection to edit') }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_library_collection_path(resource))
      fill_in('library_collection[title]', with: 'Updated Library Collection Title')
      click_button('Update Library collection')
      expect(page).to have_content('Updated Library Collection Title')
    end
  end

  context 'with a blank title' do
    it 'reports errors' do
      visit(edit_library_collection_path(resource))
      fill_in('library_collection[title]', with: '')
      click_button('Update Library collection')
      expect(page).to have_content("Title can't be blank")
    end
  end

  context 'when deleting the collection' do
    it 'removes it from the system' do
      visit(edit_library_collection_path(resource))
      click_link('Delete Library collection')
      expect(page).to have_content('Library collection to edit has been deleted')
      expect(Collection::Library.all.count).to eq(0)
      expect(adapter.index_adapter.query_service.find_all.count).to eq(0)
    end
  end
end
