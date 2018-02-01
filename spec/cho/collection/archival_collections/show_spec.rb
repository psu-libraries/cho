# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Archival, type: :feature do
  let(:collection) { create_for_repository(:archival_collection) }

  it 'displays its show page and links to the edit form' do
    visit(polymorphic_path([:solr_document], id: collection.id))
    expect(page).to have_content('Archival Collection')
    expect(page).to have_content('subtitle for an archival collection')
    expect(page).to have_content('Sample archival collection')
    expect(page).to have_content('default')
    expect(page).to have_content('public')
    click_link('Edit')
    expect(page).to have_field('archival_collection[title]', with: 'Archival Collection')
  end
end
