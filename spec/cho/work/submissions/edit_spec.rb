# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing works', type: :feature do
  let(:resource) { create_for_repository(:work, title: 'Work to edit', work_type: work_type.id) }
  let(:work_type)  { Work::Type.where(label: 'Document').first }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_work_path(resource))
      expect(page).to have_content('Editing Work')
      expect(page).to have_selector('h2', text: 'Work to edit')
      expect(page).to have_link('Show')
      fill_in('work_submission[title]', with: 'Updated Work Title')
      click_button('Update Work')
      expect(page).to have_content('Updated Work Title')
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

  context 'when deleting a work' do
    it 'removes the work from the system' do
      visit(edit_work_path(resource))
      click_link('Delete Work')
      expect(page).to have_content('Work to edit has been deleted')
      expect(Work::Submission.all.count).to eq(0)
      expect(adapter.index_adapter.query_service.find_all.count).to eq(0)
    end
  end
end
