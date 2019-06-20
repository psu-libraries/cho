# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Curated, type: :feature do
  let(:collection) { create(:curated_collection) }

  context 'when the collection has no member works' do
    it 'displays its show page and links to the edit form' do
      visit(polymorphic_path([:solr_document], id: collection.id))
      expect(page).to have_content('Curated Collection')
      expect(page).to have_content('subtitle for a curated collection')
      expect(page).to have_content('Sample curated collection')
      expect(page).to have_content('default')
      expect(page).to have_content(Repository::AccessControls::AccessLevel.public)
      click_link('Edit')
      expect(page).to have_field('curated_collection[title]', with: 'Curated Collection')
      expect(page).not_to have_link('Back')
    end
  end

  context 'with a Penn State collection' do
    let(:resource) { create(:psu_curated_collection) }

    it_behaves_like 'a resource restricted to Penn State users'
  end

  context 'with a restricted collection' do
    let(:restricted_user) { create(:user) }
    let(:resource) do
      create(:private_curated_collection,
             system_creator: restricted_user.login,
             read_users: [restricted_user.login])
    end

    it_behaves_like 'a restricted resource', with_user: :restricted_user
  end

  it_behaves_like 'a collection editable only by admins'
end
