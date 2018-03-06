# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Curated, type: :feature do
  let(:collection) { create_for_repository(:curated_collection) }

  context 'when the collection has no member works' do
    it 'displays its show page and links to the edit form' do
      visit(polymorphic_path([:solr_document], id: collection.id))
      expect(page).to have_content('Curated Collection')
      expect(page).to have_content('subtitle for a curated collection')
      expect(page).to have_content('Sample curated collection')
      expect(page).to have_content('default')
      expect(page).to have_content('public')
      click_link('Edit')
      expect(page).to have_field('curated_collection[title]', with: 'Curated Collection')
    end
  end

  it_behaves_like 'a collection with works'
end
