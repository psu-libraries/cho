# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch::SelectController, type: :feature do
  it_behaves_like 'a search form', '/select'

  context 'when deleting items' do
    let!(:work) { create(:work, :with_file_and_extracted_text, title: 'Resource to delete') }

    it 'selects items from the repository and removes them' do
      visit(root_path)
      click_link('Select Resources')
      fill_in('q', with: '')
      click_button('Search')
      within('.select-resources') do
        expect(page).to have_link('Sample Archival Collection')
        expect(page).to have_link('hello_world.txt')
        expect(page).to have_link('Resource to delete')
      end
      find("input[id='delete_ids_#{work.id}']").click
      click_button('Delete Selected Resources')
      expect(page).to have_content('The following resources will be deleted')
      expect(page).to have_selector('h2', text: 'Resource to delete (3)')
      click_button('Continue')
      expect(page).to have_content('You have successfully deleted the following: Resource to delete (3)')
    end
  end
end
