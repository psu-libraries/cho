# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Custom HTML5 validations', with_named_js: :html5_validation, type: :feature do
  def parent_div(field)
    find("label[for='work_submission_#{field}']").first(:xpath, './/..')
  end

  let!(:archival_collection) { create(:archival_collection, title: 'Sample Collection') }

  it 'reports missing required fields' do
    visit(root_path)
    click_link('Create Resource')
    click_link('Generic')
    expect(page).to have_content('New Generic Resource', wait: Capybara.default_max_wait_time * 5)
    click_button('Create Resource')
    within(parent_div(:title)) { expect(page).to have_content('Please fill out this field') }
    within(parent_div(:home_collection_id)) { expect(page).to have_content('Please fill out this field') }
    expect(find('input[type="submit"]')).to be_disabled
    fill_in('work_submission[title]', with: 'New Title')
    find('#work_submission_title').send_keys(:tab)
    within(parent_div(:title)) { expect(page).not_to have_content('Please fill out this field') }
    fill_in('work_submission[home_collection_id]', with: archival_collection.id)
    find('#work_submission_home_collection_id').send_keys(:tab)
    within(parent_div(:home_collection_id)) { expect(page).not_to have_content('Please fill out this field') }
    expect(find('input[type="submit"]')).not_to be_disabled
  end
end
