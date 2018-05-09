# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Library, type: :feature do
  let(:resource) { create(:library_collection, title: 'Library collection to edit') }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }
  let(:solr_document) { SolrDocument.find(resource.id) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_library_collection_path(resource))
      expect(page).to have_field('Description', type: 'textarea', with: 'Sample library collection')
      fill_in('library_collection[title]', with: 'Updated Library Collection Title')
      fill_in('library_collection[description]', with: 'Updated library collection description')
      click_button('Update Library collection')
      expect(page).to have_content('Updated Library Collection Title')
      expect(page).to have_content('Updated library collection description')
      expect(solr_document.title_data_dictionary_field).to eq(['Updated Library Collection Title'])
      expect(solr_document.description_data_dictionary_field).to eq(['Updated library collection description'])
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
      click_button('Delete Library collection')
      expect(page).to have_content('The following resources will be deleted')
      expect(page).to have_content(resource.title.first)
      click_button('Continue')
      expect(page).to have_content('You have successfully deleted the following items')
      expect(page).to have_content(resource.title.first)
      expect(Collection::Library.all.count).to eq(0)
      expect(adapter.index_adapter.query_service.find_all.count).to eq(0)
    end
  end
end
