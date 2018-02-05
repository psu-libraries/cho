# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing works', type: :feature do
  let(:resource) { create_for_repository(:work, title: 'Work to edit') }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_work_path(resource))
      fill_in('work_submission[title]', with: 'Updated Work Title')
      click_button('Update Generic')
      expect(page).to have_content('Updated Work Title')
    end
  end

  context 'with a blank title' do
    it 'reports errors' do
      visit(edit_work_path(resource))
      fill_in('work_submission[title]', with: '')
      click_button('Update Generic')
      expect(page).to have_content("Title can't be blank")
    end
  end

  context 'when deleting a work' do
    it 'removes the work from the system' do
      visit(edit_work_path(resource))
      click_link('Delete Generic')
      expect(page).to have_content('Work to edit has been deleted')
      expect(Work::Submission.all.count).to eq(0)
      expect(adapter.index_adapter.query_service.find_all.count).to eq(0)
    end
  end
end
