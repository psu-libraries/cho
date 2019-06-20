# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Archival, type: :feature do
  let(:collection) { create(:archival_collection, **MetadataFactory.collection_attributes) }

  context 'when the collection has many works' do
    let(:query) { page.find('.document-position-0').find_all('a').first.text }
    let(:resource_title) { page.find('.document-position-3').find_all('a').first.text }

    before do
      Array.new(15) do
        create(:work, home_collection_id: [collection.id], **MetadataFactory.work_attributes)
      end
    end

    it 'displays a paginated list of all the works in the collection' do
      visit(search_archival_collection_resources_path(collection.id))
      expect(page).to have_selector('h1', text: collection.title.first)
      expect(page).to have_link('Collection Home')
      expect(page).to have_link('Finding Aid')
      expect(page).to have_selector('legend', text: I18n.t('cho.collection.search.fieldset.legend'))
      expect(page).to have_content('1 - 10 of 15')
      click_link(resource_title)
      expect(page).to have_content(resource_title)
      expect(page).to have_link('Back to Collection Search')
      expect(page).to have_blacklight_label(:home_collection_id_tesim)
      expect(page).to have_blacklight_label(:description_tesim)
      expect(page).to have_blacklight_label(:created_tesim)
      expect(page).to have_blacklight_label(:access_rights_tesim)
    end

    it 'searches for works within the collection' do
      visit(search_archival_collection_resources_path(collection.id))
      fill_in('collection_q', with: query)
      within('#collection_search_field') do
        select('All Fields')
      end
      click_button('Search Collection')
      expect(page).to have_content(query)
    end
  end

  context 'when the collection has no works' do
    it 'shows the user that there are no works to browse' do
      visit(search_archival_collection_resources_path(collection.id))
      expect(page).to have_selector('h1', text: collection.title.first)
    end
  end
end
