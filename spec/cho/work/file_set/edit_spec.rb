# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing works', type: :feature do
  let(:resource) { create(:file_set, :with_creator, :with_member_file, title: 'File Set to Edit') }
  let(:solr_document) { SolrDocument.find(resource.id) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_file_set_path(resource))
      expect(page).to have_field('work_file_set_creator__role', with: resource.creator.first[:role])
      expect(page).to have_field('work_file_set_creator__agent', with: resource.creator.first[:agent])
      expect(page).to have_content('Editing File Set')
      expect(page).to have_selector('h2', text: 'File Set to Edit')
      expect(page).to have_link('Show')
      expect(page).to have_field('Description', type: 'textarea', with: nil)
      fill_in('work_file_set[title]', with: 'Updated File Set Title')
      fill_in('work_file_set[description][]', with: 'Updated description')
      click_button('Update File Set')
      expect(page).to have_content('Updated File Set Title')
      expect(page).to have_content('Updated description')
      expect(solr_document.title_data_dictionary_field).to eq(['Updated File Set Title'])
      expect(solr_document.description_data_dictionary_field).to eq(['Updated description'])
    end
  end

  context 'with a blank title' do
    it 'reports errors' do
      visit(edit_file_set_path(resource))
      fill_in('work_file_set[title]', with: '')
      click_button('Update File Set')
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content('1 error prohibited this file set from being saved:')
    end
  end
end
