# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Submission, type: :feature do
  let(:collection) { create :library_collection }

  before do
    create :work, title: 'Work Index View', home_collection_id: [collection.id]
  end

  it 'displays a list of fields in the search result view' do
    visit(root_path)
    fill_in(:q, with: 'Work Index View')
    click_button('Search')
    within('div#documents') do
      expect(page).to have_blacklight_label('title_tesim').with('Object Title')
      expect(page).to have_blacklight_field('title_tesim').with('Work Index View')
      expect(page).to have_blacklight_label('work_type_ssim').with('Resource Type')
      expect(page).to have_blacklight_field('work_type_ssim').with('Generic')
      expect(page).to have_blacklight_label('home_collection_id_tesim').with('Collection')
      expect(page).to have_blacklight_field('home_collection_id_tesim').with('Library Collection')
      expect(page).to have_link('Library Collection')
    end
  end
end
