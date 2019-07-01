# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Works with remote validation enabled', with_named_js: :remote_validation, type: :feature do
  def parent_div(field)
    find("label[for='work_submission_#{field}']").first(:xpath, './/..')
  end

  # Allow CSRF tokens to be generated so we can test async responses
  before(:all) { ActionController::Base.allow_forgery_protection = true }

  after(:all) { ActionController::Base.allow_forgery_protection = false }

  context 'when adding new fields for entry' do
    it 'inserts new inputs with remove links' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource', wait: Capybara.default_max_wait_time * 5)
      fill_in('work_submission[created][]', with: 'Not a date')
      find('#work_submission_created').send_keys(:tab)
      within(parent_div(:created)) do
        expect(page).to have_content('Date Not a date is not a valid EDTF date')
      end
      expect(find('input[type="submit"]')).to be_disabled
      fill_in('work_submission[created][]', with: '2001')
      find('#work_submission_created').send_keys(:tab)
      within(parent_div(:created)) do
        expect(page).not_to have_selector('#validatorMessage')
      end
      expect(find('input[type="submit"]')).not_to be_disabled
    end
  end
end
