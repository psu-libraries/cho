# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Submission, type: :feature do
  let(:collection) { create :library_collection }

  before do
    create :work, title: 'Work Index View', member_of_collection_ids: [collection.id]
  end

  it 'displays a list of fields in the search result view' do
    visit(root_path)
    fill_in(:q, with: 'Work Index View')
    click_button('Search')
    within('div#documents') do
      expect(page).to have_blacklight_label('title_tesim').with('Title')
      expect(page).to have_blacklight_field('title_tesim').with('No files')
      expect(page).to have_blacklight_label('work_type_ssim').with('Work Type')
      expect(page).to have_blacklight_field('work_type_ssim').with('Generic')
      expect(page).to have_blacklight_label('member_of_collections_ssim').with('Collections')
      expect(page).to have_blacklight_field('member_of_collections_ssim').with('Library Collection')
      expect(page).to have_link('Library Collection')
    end
  end
end
