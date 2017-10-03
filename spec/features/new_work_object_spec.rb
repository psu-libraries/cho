# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkObject do
  it 'creates a new work object' do
    visit(new_work_object_path)
    fill_in('work_object[title]', with: 'New Title')
    select('Generic', from: 'work_object[work_type]')
    click_button('Create Work object')
    expect(page).to have_content('New Title')
    expect(page).to have_content('Generic')
    expect(page).to have_link('Edit')
  end
end
