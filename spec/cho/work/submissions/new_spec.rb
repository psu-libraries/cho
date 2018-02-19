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
    it 'creates a new work object' do
      visit(root_path)
      click_link('Create Submission')
      click_link('Generic')
      expect(page).to have_content('New Generic Work')
      fill_in('work_submission[title]', with: 'New Title')
      click_button('Create Work')
      expect(page).to have_content('New Title')
      expect(page).to have_content('Generic')
      expect(page).to have_link('Edit')
    end
  end

  context 'without providing a title' do
    it 'reports the errors' do
      visit(root_path)
      click_link('Create Submission')
      click_link('Document')
      expect(page).to have_content('New Document Work')
      expect(page).to have_link('Back')
      click_button('Create Work')
      expect(page).to have_content('1 error prohibited this work from being saved:')
      expect(page).to have_content("Title can't be blank")
      fill_in('work_submission[title]', with: 'Required Title')
      click_button('Create Work')
      expect(page).to have_content('Required Title')
      expect(page).to have_content('Document')
      expect(page).to have_link('Edit')
    end
  end

  context 'with a non-existent work type' do
    it 'reports the error in the form' do
      visit(new_work_path(work_type: 'bogus-work-type-id'))
      expect(page).to have_content('Unable to find work type')
    end
  end
end
