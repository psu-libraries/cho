# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Deleting file sets', type: :feature do
  let!(:resource) { create(:file_set, :with_creator, :with_member_file, title: 'File Set to Delete') }
  let(:adapter) { Valkyrie::MetadataAdapter.find(:indexing_persister) }

  it "removes the file set and file from the system and updates the work's membership" do
    visit(polymorphic_path([:solr_document], id: Work::Submission.all.first.id))
    click_link('File Set to Delete')
    expect(page).to have_selector('td', text: 'hello_world_preservation.txt')
    click_button('Edit')
    click_button('Delete File Set')
    expect(page).to have_content('The following resources will be deleted')
    expect(page).to have_content(resource.title.first)
    expect(page).to have_selector('li', text: 'File: hello_world_preservation.txt')
    click_button('Continue')
    expect(page).to have_content('You have successfully deleted the following')
    expect(page).to have_content('File Set to Delete (1)')
    expect(Work::File.all.count).to eq(0)
    expect(Work::FileSet.all.count).to eq(0)
    expect(adapter.index_adapter.query_service.find_all.count).to eq(2)
    expect(File.exists?('tmp/files/hello_world_preservation.txt')).to be(false)
    visit(polymorphic_path([:solr_document], id: Work::Submission.all.first.id))
    expect(page).not_to have_content('File Set to Delete')
  end
end
