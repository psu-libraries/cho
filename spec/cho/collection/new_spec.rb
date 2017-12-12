# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection, type: :feature do
  context 'when filling in all the required fields' do
    it 'creates a new collection' do
      visit(new_collection_path)
      fill_in('collection[title]', with: 'New Title')
      fill_in('collection[collection_type]', with: 'archival')
      click_button('Create Collection')
      expect(page).to have_content('New Title')
      expect(page).to have_content('archival')
      expect(page).to have_link('Edit')
    end
  end

  context 'without providing a title' do
    it 'reports the errors' do
      visit(new_collection_path)
      fill_in('collection[collection_type]', with: 'archival')
      click_button('Create Collection')
      expect(page).to have_content("Title can't be blank")
    end
  end
end
