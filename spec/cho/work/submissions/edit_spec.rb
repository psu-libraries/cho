# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing works', type: :feature do
  let(:resource) { create(:work, :with_creator, :with_metadata, title: 'Work to edit', work_type_id: work_type.id) }
  let(:work_type)  { Work::Type.where(label: 'Document').first }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }
  let(:solr_document) { SolrDocument.find(resource.id) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_work_path(resource))
      expect(page).to have_field('work_submission_creator__role', with: resource.creator.first[:role])
      expect(page).to have_field('work_submission_creator__agent', with: resource.creator.first[:agent])
      expect(page).to have_content('Editing Resource')
      expect(page).to have_selector('h2', text: 'Work to edit')
      expect(page).to have_selector('input[type=submit][value=Show]')
      expect(page).to have_field('Description', type: 'textarea', with: nil)
      expect(page).not_to have_field('work_submission[file]')
      fill_in('work_submission[title]', with: 'Updated Work Title')
      fill_in('work_submission[description][]', with: 'Updated description')
      click_button('Update Resource')
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
      click_button('Update Resource')
      within('.error-explanation') do
        expect(page).to have_content('1 error prohibited this resource from being saved:')
        expect(page).to have_css('ul li', text: "can't be blank")
      end
    end
  end
end
