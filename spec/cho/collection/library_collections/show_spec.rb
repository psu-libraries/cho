# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Library, type: :feature do
  let(:collection) { create_for_repository(:library_collection) }

  it 'displays its show page and links to the edit form' do
    visit(polymorphic_path([:solr_document], id: collection.id))
    expect(page).to have_content('Library Collection')
    expect(page).to have_content('subtitle for a library collection')
    expect(page).to have_content('Sample library collection')
    expect(page).to have_content('default')
    expect(page).to have_content('public')
    click_link('Edit')
    expect(page).to have_field('library_collection[title]', with: 'Library Collection')
  end
end
