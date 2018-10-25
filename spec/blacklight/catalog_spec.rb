# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatalogController, type: :feature do
  it_behaves_like 'a search form', '/catalog'

  context 'when searching for works' do
    before do
      create(:work_submission, :with_file,
        collection_title: 'Searching Collection',
        generic_field: 'Faceted Value')
    end

    it 'returns the work and excludes file sets and files' do
      visit(root_path)

      # Check facets
      within('div.blacklight-member_of_collection_ssim') do
        expect(page).to have_selector('h3', text: 'Collections')
        expect(page).to have_link('Searching Collection')
      end
      within('div.blacklight-work_type_ssim') do
        expect(page).to have_selector('h3', text: 'Work Type')
        expect(page).to have_link('Generic')
      end
      within('div.blacklight-collection_type_ssim') do
        expect(page).to have_selector('h3', text: 'Collection Type')
        expect(page).to have_link('Archival Collection')
      end
      within('div.blacklight-generic_field_ssim') do
        expect(page).to have_selector('h3', text: 'Generic Field')
        expect(page).to have_link('Faceted Value')
      end

      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
        expect(page).not_to have_content('hello_world.txt')
        expect(page).not_to have_content(Work::File.all.first.id)
      end
    end

    it 'returns the work when searching for the title of the file' do
      visit(root_path)
      fill_in('q', with: 'hello_world.txt')
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end
  end

  context 'when searching extracted text' do
    before do
      create(:work_submission, :with_file,
        filename: 'example_extracted_text.txt',
        title: 'Sample Extracted Text Work')
    end

    it 'returns the work containing the extracted text' do
      visit(root_path)
      fill_in('q', with: 'words')
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Extracted Text Work')
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
