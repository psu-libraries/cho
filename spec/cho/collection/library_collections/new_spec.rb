# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Library, type: :feature do
  context 'when filling in all the required fields' do
    it 'creates a new archival collection' do
      visit(new_library_collection_path)
      fill_in('library_collection[title]', with: 'New Title')
      fill_in('library_collection[subtitle]', with: 'new subtitle')
      fill_in('library_collection[description]', with: 'Description of new collection')
      choose('Mediated')
      choose('PSU Access')
      click_button('Create Library collection')
      expect(page).to have_content('New Title')
      expect(page).to have_content('new subtitle')
      expect(page).to have_content('Description of new collection')
      expect(page).to have_content('mediated')
      expect(page).to have_content('authenticated')
    end
  end

  context 'without providing the required metadata' do
    before { create(:collection, alternate_ids: 'existing-id') }

    it 'reports the errors' do
      visit(new_library_collection_path)
      fill_in('library_collection[alternate_ids]', with: 'existing-id')
      click_button('Create Library collection')
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content('Alternate ids existing-id already exists')
    end
  end
end
