# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home Page', type: :feature do
  it 'has all the navigation options' do
    visit('/')
    expect(page).to have_content('Cultural Heritage Objects')
    expect(page).to have_link('New Work Object')
    expect(page).to have_link('Data Dictionary')
    click_link('New Work Object')
    expect(page).to have_css("form[action='/work_objects']")
    click_link('Data Dictionary')
    expect(page).to have_content('Data Dictionary Fields')
    expect(page).to have_link('Create Collection')
    click_link('Archival Collection')
    expect(page).to have_content('New Archival Collection')
    click_link('Library Collection')
    expect(page).to have_content('New Library Collection')
    click_link('Curated Collection')
    expect(page).to have_content('New Curated Collection')
  end
end
