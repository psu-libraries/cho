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
      fill_in('q', with: 'hello_world.txt')
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the part of the title of the file' do
      visit(root_path)
      fill_in('q', with: 'hello')
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the alternate id' do
      visit(root_path)
      fill_in('q', with: 'abc')
      within('#search_field') do
        select('Alternate Id')
      end
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the alternate id in all fields' do
      visit(root_path)
      fill_in('q', with: 'abc')
      within('#search_field') do
        select('All Fields')
      end
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the description bree-hobbits' do
      visit(root_path)
      fill_in('q', with: 'bree-hobbits')
      within('#search_field') do
        select('Description')
      end
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Generic Work')
      end
    end

    it 'returns the work when searching for the creator' do
      visit(root_path)
      fill_in('q', with: 'Doe, John')
      within('#search_field') do
        select('Creator')
      end
      click_button('Search')
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
      fill_in('q', with: 'words')
      click_button('Search')
      within('#documents') do
        expect(page).to have_link('Sample Extracted Text Work')
      end
    end
  end

  describe 'searching collections' do
    let(:private_user) { create(:user) }

    before do
      create(:archival_collection)
      create(:curated_collection)
      create(:library_collection)
      create(:psu_collection, title: 'PSU-only Collection')
      create(:work_submission, :with_file, title: 'Public Work')

      create(:restricted_collection,
             title: 'Restricted Readable Collection',
             system_creator: private_user.login,
             read_users: [private_user.login])
    end

    context 'with a public user', :with_public_user do
      it 'returns only public collections and works, excluding file sets and files' do
        visit(root_path)
        click_button('Search')
        within('#documents') do
          expect(page).to have_link('Archival Collection')
          expect(page).to have_link('Library Collection')
          expect(page).to have_link('Public Work')
          expect(page).not_to have_link('PSU-only Collection')
          expect(page).not_to have_link('Restricted Collection')
          expect(page).not_to have_content('hello_world.txt')
          expect(page).not_to have_content(Work::File.all.first.id)
        end
      end
    end

    context 'with a PSU user', :with_psu_user do
      it 'returns all public and Penn State collections and works, excluding file sets and files' do
        visit(root_path)
        click_button('Search')
        within('#documents') do
          expect(page).to have_link('Archival Collection')
          expect(page).to have_link('Library Collection')
          expect(page).to have_link('Public Work')
          expect(page).to have_link('PSU-only Collection')
          expect(page).not_to have_link('Restricted Collection')
          expect(page).not_to have_content('hello_world.txt')
          expect(page).not_to have_content(Work::File.all.first.id)
        end
      end
    end

    context 'with a private user', with_user: :private_user do
      it 'returns all public, Penn State, and restricted collections and works, excluding file sets and files' do
        visit(root_path)
        click_button('Search')
        within('#documents') do
          expect(page).to have_link('Archival Collection')
          expect(page).to have_link('Library Collection')
          expect(page).to have_link('Public Work')
          expect(page).to have_link('PSU-only Collection')
          expect(page).to have_link('Restricted Readable Collection')
          expect(page).not_to have_content('hello_world.txt')
          expect(page).not_to have_content(Work::File.all.first.id)
        end
      end
    end

    context 'with an admin' do
      it 'returns all collections and works, excluding file sets and files' do
        visit(root_path)
        click_button('Search')
        within('#documents') do
          expect(page).to have_link('Archival Collection')
          expect(page).to have_link('Library Collection')
          expect(page).to have_link('Public Work')
          expect(page).to have_link('PSU-only Collection')
          expect(page).to have_link('Restricted Readable Collection')
          expect(page).not_to have_content('hello_world.txt')
          expect(page).not_to have_content(Work::File.all.first.id)
        end
      end
    end
  end
end
