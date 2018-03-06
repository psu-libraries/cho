# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Search History Page', type: :feature do
  describe 'when I have done a search' do
    before do
      visit '/'
      fill_in 'q', with: 'book'
      click_button 'search'
      click_link 'History'
    end
    it 'shows searches' do
      expect(page).to have_content 'Your recent searches'
      expect(page).to have_content 'book'
      expect(page).not_to have_content 'dang'
      visit '/'
      fill_in 'q', with: 'dang'
      click_button 'search'
      click_link 'History'
      expect(page).to have_selector('ul')
      expect(page).to have_content 'book'
      expect(page).to have_content 'dang'
    end
  end
end
