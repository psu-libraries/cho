# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing a work object', type: :feature do
  let(:work) { create_for_repository(:work, title: 'An editable file') }

  it 'displays its show page and links to the edit form' do
    visit(polymorphic_path([:solr_document], id: work.id))
    expect(page).to have_content('An editable file')
    expect(page).to have_content('Generic')
    click_link('Edit')
    expect(page).to have_field('work_object_deposit[title]', with: 'An editable file')
    expect(page).not_to have_select('work_object_deposit[work_type]', with_selected: 'Generic')
  end
end
