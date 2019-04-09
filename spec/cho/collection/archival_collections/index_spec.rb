# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Archival, type: :feature do
  before { create(:archival_collection, title: 'Archival collection index view') }

  it 'displays facets and the collection in an index view' do
    visit(search_catalog_path)
    within('div#facet-collection_type_ssim') do
      click_link('Archival Collection')
    end
    within('div.documents-list') do
      expect(page).to have_link('Archival collection index view')
      expect(page).to have_blacklight_label('title_tesim')
      expect(page).to have_blacklight_field('title_tesim').with('Archival collection index view')
      expect(page).to have_blacklight_label('collection_type_ssim')
      expect(page).to have_blacklight_field('collection_type_ssim').with('Archival Collection')
    end
  end
end
