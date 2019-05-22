# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Archival, type: :feature do
  let(:collection) { create :archival_collection }

  context 'when the collection has no member works' do
    it 'displays its show page and links to the edit form' do
      visit(polymorphic_path([:solr_document], id: collection.id))
      expect(page).to have_content('Archival Collection')
      expect(page).to have_content('subtitle for an archival collection')
      expect(page).to have_content('Sample archival collection')
      expect(page).to have_content('default')
      expect(page).to have_content(Repository::AccessLevel.public)
      click_button('Edit')
      expect(page).to have_field('archival_collection[title]', with: 'Archival Collection')
      expect(page).not_to have_link('Back')
    end
  end

  context 'with a Penn State collection' do
    let(:resource) { create(:psu_collection) }

    it_behaves_like 'a resource restricted to Penn State users'
  end

  it_behaves_like 'a collection with works'

  it_behaves_like 'a collection editable only by admins'
end
