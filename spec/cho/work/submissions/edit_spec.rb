# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing works', type: :feature do
  let(:resource) { create(:work, :with_creator, title: 'Work to edit', work_type_id: work_type.id) }
  let(:work_type)  { Work::Type.where(label: 'Document').first }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }
  let(:solr_document) { SolrDocument.find(resource.id) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_work_path(resource))
      expect(page).to have_field('work_submission_creator_role', with: resource.creator.first[:role])
      expect(page).to have_field('work_submission_creator_agent', with: resource.creator.first[:agent])
      expect(page).to have_content('Editing Work')
      expect(page).to have_selector('h2', text: 'Work to edit')
      expect(page).to have_link('Show')
      expect(page).to have_field('Description', type: 'textarea', with: nil)
      fill_in('work_submission[title]', with: 'Updated Work Title')
      fill_in('work_submission[description]', with: 'Updated description')
      click_button('Update Work')
      expect(page).to have_content('Updated Work Title')
      expect(page).to have_content('Updated description')
      expect(solr_document.title_data_dictionary_field).to eq(['Updated Work Title'])
      expect(solr_document.description_data_dictionary_field).to eq(['Updated description'])
    end
  end

  context 'with a blank title' do
    it 'reports errors' do
      visit(edit_work_path(resource))
      fill_in('work_submission[title]', with: '')
      click_button('Update Work')
      expect(page).to have_content("Title can't be blank")
      expect(page).to have_content('1 error prohibited this work from being saved:')
    end
  end
end
