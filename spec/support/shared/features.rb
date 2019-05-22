# frozen_string_literal: true

RSpec.shared_examples 'a search form' do |path|
  context 'with no items in the repository' do
    let(:query) { 'search query' }

    it 'returns a null search' do
      visit(path)
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

  context 'with an existing work' do
    let(:query) { 'exceptional' }

    before { create(:work, title: 'Some exceptional content') }

    it 'searches and facets on the item' do
      visit(path)
      fill_in('q', with: query)
      click_button('Search')
      within('.constraints-container') do
        expect(page).to have_link('Start Over')
        expect(page).to have_link("Remove constraint #{query}")
        expect(page).to have_content("You searched for: #{query}")
      end
      expect(page).to have_content('Some exceptional content')
      within('.facet-limit.blacklight-work_type_ssim') do
        click_link('Generic')
      end
      within('.constraints-container') do
        expect(page).to have_link('Remove constraint Resource Type: Generic')
      end
      expect(page).to have_content('Some exceptional content')
    end
  end
end

RSpec.shared_examples 'a resource restricted to Penn State users' do
  it 'renders an error page', :with_public_user do
    visit(polymorphic_path([:solr_document], id: resource.id))
    expect(page).to have_content('You are not allowed to access this page')
  end

  it 'displays the resource', :with_psu_user do
    visit(polymorphic_path([:solr_document], id: resource.id))
    expect(page).not_to have_content('You are not allowed to access this page')
    expect(page).to have_content(resource.title.first)
  end
end
