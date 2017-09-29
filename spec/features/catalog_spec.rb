# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Catalog page' do
  let(:query) { 'search query' }

  it 'executes a search' do
    visit('/catalog')
    fill_in('q', with: query)
    click_button('Search')
    within('.constraints-container') do
      expect(page).to have_link('Start Over')
      expect(page).to have_link("Remove constraint #{query}")
      expect(page).to have_content("You searched for: #{query}")
    end
    expect(page).to have_content('No results found for your search')
  end
end
