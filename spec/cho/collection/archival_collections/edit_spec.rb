# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Archival, type: :feature do
  let(:resource) { create_for_repository(:archival_collection, title: 'Archival collection to edit') }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_archival_collection_path(resource))
      fill_in('archival_collection[title]', with: 'Updated Archival Collection Title')
      click_button('Update Archival collection')
      expect(page).to have_content('Updated Archival Collection Title')
    end
  end

  context 'with a blank title' do
    it 'reports errors' do
      visit(edit_archival_collection_path(resource))
      fill_in('archival_collection[title]', with: '')
      click_button('Update Archival collection')
      expect(page).to have_content("Title can't be blank")
    end
  end

  context 'when deleting the collection' do
    it 'removes it from the system' do
      visit(edit_archival_collection_path(resource))
      click_link('Delete Archival collection')
      expect(page).to have_content('Archival collection to edit has been deleted')
      expect(Collection::Archival.all.count).to eq(0)
      expect(adapter.index_adapter.query_service.find_all.count).to eq(0)
    end
  end
end
