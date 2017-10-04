# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing work objects' do
  let(:work) { build(:work, title: 'Work to edit') }
  let(:resource) { Valkyrie.config.metadata_adapter.persister.save(resource: work) }

  context 'with all the required metadata' do
    it 'updates an existing work with new metadata' do
      visit(edit_work_object_path(resource))
      fill_in('work_object[title]', with: 'Updated Work Title')
      click_button('Update Generic')
      expect(page).to have_content('Updated Work Title')
    end
  end

  context 'with a blank title' do
    it 'reports errors' do
      visit(edit_work_object_path(resource))
      fill_in('work_object[title]', with: '')
      click_button('Update Generic')
      expect(page).to have_content("Title can't be blank")
    end
  end
end
