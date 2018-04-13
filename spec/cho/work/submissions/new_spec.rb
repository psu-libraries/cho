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
    let!(:archival_collection) { create_for_repository(:archival_collection, title: 'Sample Collection') }

    it 'creates a new work object' do
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
    let!(:archival_collection) { create_for_repository(:archival_collection, title: 'Sample Collection') }

    it 'reports the errors' do
      visit(root_path)
      click_link('Create Work')
      click_link('Document')
      expect(page).to have_content('New Document Work')
      click_button('Create Work')
      within('#error_explanation') do
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
end
