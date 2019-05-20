# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Library, type: :feature do
  let(:collection) { create :library_collection }

  context 'when the collection has no member works' do
    it 'displays its show page and links to the edit form' do
      visit(polymorphic_path([:solr_document], id: collection.id))
      expect(page).to have_content('Library Collection')
      expect(page).to have_content('subtitle for a library collection')
      expect(page).to have_content('Sample library collection')
      expect(page).to have_content('default')
      expect(page).to have_content('public')
      click_button('Edit')
      expect(page).to have_field('library_collection[title]', with: 'Library Collection')
      expect(page).not_to have_link('Back')
    end
  end

  it_behaves_like 'a collection with works'

  it_behaves_like 'a collection editable only by admins'
end
