# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Editing work objects' do
  let(:work) { build(:work, title: 'Work to edit') }
  let(:resource) { Valkyrie.config.metadata_adapter.persister.save(resource: work) }

  it 'updates an existing work with new metadata' do
    visit(edit_work_object_path(resource))
    fill_in('work_object[title]', with: 'Updated Work Title')
    click_button('Update Work object')
    expect(page).to have_content('Updated Work Title')
  end
end
