# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatalogController, type: :feature do
  it_behaves_like 'a search form', '/catalog'

  describe 'searching for works' do
    before do
      create(:work_submission, :with_file, :with_creator,
             collection_title: 'Searching Collection',
             generic_field: 'Faceted Value',
             alternate_ids: ['abc_123_999'],
             date_cataloged: ['1965/1975'],
             description: 'Barahir son of bregor bree-hobbits chieftain of the north harlindon northern mirkwood orleg
                           orocarni pass of imladris sun white mountains.')
    end

    it 'returns the work and excludes file sets and files' do
      visit(search_catalog_path)

      # Check facets
      within('div.blacklight-home_collection_id_ssim') do
        expect(page).to have_selector('h3[data-target="#facet-home_collection_id_ssim"]')
        expect(page).to have_link('Searching Collection')
      end
      within('div.blacklight-work_type_ssim') do
        expect(page).to have_selector('h3[data-target="#facet-work_type_ssim"]')
        expect(page).to have_link('Generic')
      end
      within('div.blacklight-collection_type_ssim') do
        expect(page).to have_selector('h3[data-target="#facet-collection_type_ssim"]')
        expect(page).to have_link('Archival Collection')
      end
      within('div.blacklight-generic_field_ssim') do
        expect(page).to have_selector('h3[data-target="#facet-generic_field_ssim"]')
        expect(page).to have_link('Faceted Value')
      end
      within('div.blacklight-creator_role_ssim') do
        expect(page).to have_selector('h3[data-target="#facet-creator_role_ssim"]')
        expect(page).to have_link('blasting')
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
      search_for 'hello_world.txt'
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the part of the title of the file' do
      visit(root_path)
      search_for 'hello'
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the alternate id' do
      visit(root_path)
      search_for 'abc', in: 'Alternate Id'
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the alternate id in all fields' do
      visit(root_path)
      search_for 'abc', in: 'All Fields'
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the description bree-hobbits' do
      visit(root_path)
      search_for 'bree-hobbits', in: 'Description'
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the creator' do
      visit(root_path)
      search_for 'Doe, John', in: 'Creator'
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching within the edtf range' do
      visit(root_path)
      search_for '1970', in: 'Date Cataloged'
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end
  end

  describe 'searching extracted text' do
    before do
      create(:work_submission, :with_file_and_extracted_text,
             filename: 'example_extracted_text.txt',
             title: 'Sample Extracted Text Work')
    end

    it 'returns the work containing the extracted text' do
      visit(root_path)
      search_for 'words'
      within('#documents') do
        expect(page).to have_link('Sample Extracted Text Work')
      end
    end
  end

  describe 'searching collections' do
    before do
      create(:archival_collection)
      create(:curated_collection)
      create(:library_collection)
      create(:psu_collection, title: 'PSU-only Collection')
      create(:work_submission, :with_file)
    end

    context 'with a public user', :with_public_user do
      it 'returns only the public collections and excludes file sets and files' do
        visit(root_path)
        click_button('Search')
        within('#documents') do
          expect(page).to have_link('Archival Collection')
          expect(page).to have_link('Library Collection')
          expect(page).not_to have_link('PSU-only Collection')
          expect(page).not_to have_content('hello_world.txt')
          expect(page).not_to have_content(Work::File.all.first.id)
          click_link('Curated Collection')
        end
        expect(page).not_to have_content('You are not allowed to access this page')
        expect(page).to have_content('Curated Collection')
      end
    end

    context 'with a PSU user', :with_psu_user do
      it 'returns both the public and restricted collections, excluding file sets and files' do
        visit(root_path)
        click_button('Search')
        within('#documents') do
          expect(page).to have_link('Archival Collection')
          expect(page).to have_link('Library Collection')
          expect(page).to have_link('PSU-only Collection')
          expect(page).not_to have_content('hello_world.txt')
          expect(page).not_to have_content(Work::File.all.first.id)
          click_link('Curated Collection')
        end
        expect(page).not_to have_content('You are not allowed to access this page')
        expect(page).to have_content('Curated Collection')
      end
    end
  end

  def search_for(query, options = {})
    fill_in('q', with: query)
    within('#search_field') do
      select(options.fetch(:in, 'All Fields'))
    end
    click_button('Search')
  end
end
