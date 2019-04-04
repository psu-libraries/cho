# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Library, type: :feature do
  before { create(:library_collection, title: 'Library collection index view') }

  it 'displays facets and the collection in an index view' do
    visit(root_path)
    within('div#facet-collection_type_ssim') do
      click_link('Library Collection')
    end
    within('div.documents-list') do
      expect(page).to have_link('Library collection index view')
      expect(page).to have_blacklight_label('title_tesim')
      expect(page).to have_blacklight_field('title_tesim').with('Library collection index view')
      expect(page).to have_blacklight_label('collection_type_ssim')
      expect(page).to have_blacklight_field('collection_type_ssim').with('Library Collection')
    end
  end
end
