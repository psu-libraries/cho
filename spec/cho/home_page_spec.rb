# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home Page', type: :feature do
  context 'as an admin user' do
    it 'has all the navigation options' do
      visit('/')
      expect(page).to have_content('Cultural Heritage Objects')
      expect(page).to have_link('Skip to main content')
      expect(page).to have_selector('main')
      expect(page).to have_link('Data Dictionary')
      click_link('Data Dictionary')
      expect(page).to have_content('Data Dictionary Fields')
      expect(page).to have_link('Create Collection')
      click_link('Archival Collection')
      expect(page).to have_content('New Archival Collection')
      click_link('Library Collection')
      expect(page).to have_content('New Library Collection')
      click_link('Curated Collection')
      expect(page).to have_content('New Curated Collection')
      expect(page).to have_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource')
      click_link('Document')
      expect(page).to have_content('New Document Resource')
    end
  end

  context 'as a non-admin user', :with_psu_user do
    it 'does not link to management or resource creation' do
      visit('/')
      expect(page).to have_content('Cultural Heritage Objects')
      expect(page).to have_link('Skip to main content')
      expect(page).to have_selector('main')
      expect(page).not_to have_link('Data Dictionary')
      expect(page).not_to have_link('Create Collection')
      expect(page).not_to have_content('New Archival Collection')
      expect(page).not_to have_content('New Library Collection')
      expect(page).not_to have_content('New Curated Collection')
      expect(page).not_to have_link('Create Resource')
      expect(page).not_to have_content('New Generic Resource')
      expect(page).not_to have_content('New Document Resource')
    end
  end
end
