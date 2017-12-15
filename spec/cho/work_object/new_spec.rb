# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkObject::Deposit, type: :feature do
  context 'when filling in all the required fields' do
    it 'creates a new work object' do
      visit(new_work_object_path)
      fill_in('work_object_deposit[title]', with: 'New Title')
      select('Generic', from: 'work_object_deposit[work_type]')
      click_button('Create Deposit')
      expect(page).to have_content('New Title')
      expect(page).to have_content('Generic')
      expect(page).to have_link('Edit')
    end
  end

  context 'without providing a title' do
    it 'reports the errors' do
      visit(new_work_object_path)
      select('Generic', from: 'work_object_deposit[work_type]')
      click_button('Create Deposit')
      expect(page).to have_content("Title can't be blank")
    end
  end
end
