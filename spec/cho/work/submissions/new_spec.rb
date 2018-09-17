# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Submission, type: :feature do
  context 'when no work type is provided' do
    it 'redirects to the home page with an error' do
      visit(new_work_path)
      expect(page).to have_content('You must specify a work type')
    end
  end

  context 'when filling in all the required fields' do
    let!(:archival_collection) { create(:archival_collection, title: 'Sample Collection') }

    it 'creates a new work object without a file' do
      visit(root_path)
      click_link('Create Work')
      click_link('Generic')
      expect(page).to have_content('New Generic Work')
      fill_in('work_submission[title]', with: 'New Title')
      fill_in('work_submission[member_of_collection_ids][]', with: archival_collection.id)
      click_button('Create Work')
      expect(page).to have_content('New Title')
      expect(page).to have_content('Generic')
      expect(page).to have_link('Edit')
    end
  end

  context 'without providing a title' do
    let!(:archival_collection) { create(:archival_collection, title: 'Sample Collection') }

    it 'reports the errors' do
      visit(root_path)
      click_link('Create Work')
      click_link('Document')
      expect(page).to have_content('New Document Work')
      click_button('Create Work')
      within('.error-explanation') do
        expect(page).to have_selector('h2', text: '2 errors prohibited this work from being saved:')
        expect(page).to have_content("Title can't be blank")
        expect(page).to have_content('Member of collection ids does not exist')
      end
      fill_in('work_submission[title]', with: 'Required Title')
      fill_in('work_submission[member_of_collection_ids][]', with: archival_collection.id)
      click_button('Create Work')
      expect(page).to have_content('Required Title')
      expect(page).to have_content('Document')
      expect(page).to have_link('Edit')
    end
  end

  context 'with a non-existent work type' do
    it 'reports the error in the form' do
      visit(new_work_path(work_type_id: 'bogus-work-type-id'))
      expect(page).to have_content('Unable to find work type')
    end
  end

  context 'when attaching a file' do
    let!(:archival_collection) { create(:archival_collection, title: 'Sample Collection with Files') }

    it 'creates a new work object with a file' do
      visit(root_path)
      click_link('Create Work')
      click_link('Generic')
      expect(page).to have_content('New Generic Work')
      fill_in('work_submission[title]', with: 'New Title')
      fill_in('work_submission[member_of_collection_ids][]', with: archival_collection.id)
      attach_file('File Selection', Pathname.new(fixture_path).join('hello_world.txt'))
      click_button('Create Work')
      expect(page).to have_content('New Title')
      expect(page).to have_content('Generic')
      expect(page).to have_link('Edit')
      expect(page).to have_selector('h2', text: 'Files')
      expect(page).to have_content('hello_world.txt')
    end
  end

  context 'when attaching a zip file to the work' do
    let!(:archival_collection) { create(:archival_collection, title: 'Collection with zipped work') }

    let(:bag) do
      ImportFactory::Bag.create(
        batch_id: 'batch1_2018-09-10',
        data: {
          work1: ['work1_preservation.tif']
        }
      )
    end

    let(:zip_file) { ImportFactory::Zip.create(bag) }

    it 'creates a new work object with files from zip' do
      visit(root_path)
      click_link('Create Work')
      click_link('Generic')
      expect(page).to have_content('New Generic Work')
      fill_in('work_submission[title]', with: 'Work with attached zip')
      fill_in('work_submission[member_of_collection_ids][]', with: archival_collection.id)
      attach_file('File Selection', zip_file)
      click_button('Create Work')
      expect(page).to have_content('Work with attached zip')
      expect(page).to have_content('Generic')
      expect(page).to have_link('Edit')
      expect(page).to have_selector('h2', text: 'Files')
      expect(page).to have_content('work1_preservation.tif')
    end
  end

  context 'when adding the work to a library collection' do
    let!(:library_collection) { create(:library_collection, title: 'Adding to Library Collection') }

    it 'creates a new work object without a file' do
      visit(root_path)
      click_link('Create Work')
      click_link('Generic')
      expect(page).to have_content('New Generic Work')
      fill_in('work_submission[title]', with: 'kingsfoil longbottom')
      fill_in('work_submission[member_of_collection_ids][]', with: library_collection.id)
      click_button('Create Work')
      expect(page).to have_content('kingsfoil longbottom')
      expect(page).to have_content('Generic')
      expect(page).to have_content('Adding to Library Collection')
      expect(page).to have_link('Edit')
    end
  end
end
