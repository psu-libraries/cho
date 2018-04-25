# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Curated, type: :feature do
  let(:resource) { create(:curated_collection, title: 'Curated collection to edit') }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_curated_collection_path(resource))
      fill_in('curated_collection[title]', with: 'Updated Curated Collection Title')
      click_button('Update Curated collection')
      expect(page).to have_content('Updated Curated Collection Title')
    end
  end

  context 'with a blank title' do
    it 'reports errors' do
      visit(edit_curated_collection_path(resource))
      fill_in('curated_collection[title]', with: '')
      click_button('Update Curated collection')
      expect(page).to have_content("Title can't be blank")
    end
  end

  context 'when deleting the collection' do
    it 'removes it from the system' do
      visit(edit_curated_collection_path(resource))
      click_button('Delete Curated collection')
      expect(page).to have_content('The following resources will be deleted')
      expect(page).to have_content(resource.title.first)
      click_button('Continue')
      expect(page).to have_content('You have successfully deleted the following items')
      expect(page).to have_content(resource.title.first)
      expect(Collection::Curated.all.count).to eq(0)
      expect(adapter.index_adapter.query_service.find_all.count).to eq(0)
    end
  end
end
