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
      expect(page).to have_content(Repository::AccessControls::AccessLevel.public)
      click_button('Edit')
      expect(page).to have_field('library_collection[title]', with: 'Library Collection')
      expect(page).not_to have_link('Back')
    end
  end

  context 'with a Penn State collection' do
    let(:resource) { create(:psu_library_collection) }

    it_behaves_like 'a resource restricted to Penn State users'
  end

  context 'with a restricted collection' do
    let(:restricted_user) { create(:user) }
    let(:resource) do
      create(:private_library_collection,
             system_creator: restricted_user.login,
             read_users: [restricted_user.login])
    end

    it_behaves_like 'a restricted resource', with_user: :restricted_user
  end

  # it_behaves_like 'a collection with works'

  it_behaves_like 'a collection editable only by admins'
end
