# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deleting works', type: :feature do
  let(:resource) { create(:work, :with_file_and_extracted_text, title: 'Work to delete') }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

  it 'removes the work and file from the system but retains its parent collection' do
    visit(polymorphic_path([:solr_document], id: resource.id))
    expect(page).to have_selector('li', text: 'hello_world.txt')
    click_link('Edit')
    click_button('Delete Resource')
    expect(page).to have_content('The following resources will be deleted')
    expect(page).to have_content(resource.title.first)
    expect(page).to have_selector('li', text: 'File set: hello_world.txt')
    expect(page).to have_selector('li', text: 'File: hello_world.txt')
    expect(page).to have_selector('li', text: 'File: hello_world.txt_text.txt')
    click_button('Continue')
    expect(page).to have_content('You have successfully deleted the following')
    expect(page).to have_content('Work to delete (3)')
    expect(Work::Submission.all.count).to eq(0)
    expect(Work::File.all.count).to eq(0)
    expect(Collection::Archival.all.count).to eq(1)
    expect(adapter.index_adapter.query_service.find_all.count).to eq(1)
    expect(File.exists?('tmp/files/hello_world.txt')).to be(false)
  end
end
