# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatalogController, type: :feature do
  it_behaves_like 'a search form', '/catalog'

  context 'when searching for works' do
    before { create(:work_submission, :with_file) }

    it 'returns the work and excludes file sets and files' do
      visit(root_path)
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
        expect(page).not_to have_content('hello_world.txt')
        expect(page).not_to have_content(Work::File.all.first.id)
      end
    end

    it 'returns the work when searcghing for the title of the file' do
      visit(root_path)
      fill_in('q', with: 'hello_world.txt')
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end
  end

  context 'when searching for collections' do
    before do
      create(:archival_collection)
      create(:curated_collection)
      create(:library_collection)
      create(:work_submission, :with_file)
    end
    it 'returns the collection and excludes file sets and files' do
      visit(root_path)
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Archival Collection')
        expect(page).to have_link('Curated Collection')
        expect(page).to have_link('Library Collection')
        expect(page).not_to have_content('hello_world.txt')
        expect(page).not_to have_content(Work::File.all.first.id)
      end
    end
  end
end
