# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Batch::SelectController, type: :feature do
  it_behaves_like 'a search form', '/select'

  context 'when deleting items' do
    before { create(:work, title: 'Resource to delete') }

    it 'selects items from the repository and removes them' do
      visit(root_path)
      click_link('Select Resources')
      fill_in('q', with: 'Resource to delete')
      click_button('Search')
      find("input[type='checkbox']").click
      click_button('Delete Selected Resources')
      expect(page).to have_content('The following resources will be deleted')
      expect(page).to have_selector('li', text: 'Resource to delete')
      click_button('Continue')
      expect(page).to have_content('You have successfully deleted the following items: Resource to delete ')
    end
  end
end
