# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Catalog page', type: :feature do
  context 'with no items in the repository' do
    let(:query) { 'search query' }

    it 'returns a null search' do
      visit('/catalog')
      fill_in('q', with: query)
      expect(page).to have_select('search_field', options: ['Title', 'All Fields', 'Author', 'Subject'])
      click_button('Search')
      within('.constraints-container') do
        expect(page).to have_link('Start Over')
        expect(page).to have_link("Remove constraint #{query}")
        expect(page).to have_content("You searched for: #{query}")
      end
      expect(page).to have_content('No results found for your search')
    end
  end

  context 'with an existing work' do
    let(:work)  { build(:work, title: 'Some exceptional content') }
    let(:query) { 'exceptional' }

    # @todo this only persists the object into Solr; could use FactoryGirl here to make it easier.
    before { Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work) }

    it 'searches and facets on the item' do
      visit('/catalog')
      fill_in('q', with: query)
      click_button('Search')
      within('.constraints-container') do
        expect(page).to have_link('Start Over')
        expect(page).to have_link("Remove constraint #{query}")
        expect(page).to have_content("You searched for: #{query}")
      end
      expect(page).to have_content('Some exceptional content')
      within('.facet_limit.blacklight-work_type_ssim') do
        click_link('Generic')
      end
      within('.constraints-container') do
        expect(page).to have_link('Remove constraint Work Type: Generic')
      end
      expect(page).to have_content('Some exceptional content')
    end
  end
end
