# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing a collection', type: :feature do
  let(:collection) { create_for_repository(:collection) }

  it 'displays its show page and links to the edit form' do
    visit(polymorphic_path([:solr_document], id: collection.id))
    expect(page).to have_content('Archival Collection')
    click_link('Edit')
    expect(page).to have_field('collection[title]', with: 'Archival Collection')
  end
end
