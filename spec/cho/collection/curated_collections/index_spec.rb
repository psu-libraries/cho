# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Curated, type: :feature do
  before { create(:curated_collection, title: 'Curated collection index view') }

  it 'displays facets and the collection in an index view' do
    visit(search_catalog_path)
    within('div#facet-collection_type_ssim') do
      click_link('Curated Collection')
    end
    within('div.documents-list') do
      expect(page).to have_link('Curated collection index view')
      expect(page).to have_blacklight_label('title_tesim')
      expect(page).to have_blacklight_field('title_tesim').with('Curated collection index view')
      expect(page).to have_blacklight_label('collection_type_ssim')
      expect(page).to have_blacklight_field('collection_type_ssim').with('Curated Collection')
    end
  end
end
