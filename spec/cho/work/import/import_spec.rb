# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preview of CSV Import', type: :feature do
  let(:collection) { create :library_collection, title: 'my collection' }
  let(:work_1_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world.txt') }
  let(:work_2_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world2.txt') }
  let(:work_3_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world3.txt') }
  let(:csv_file) do
    csv_file = Tempfile.new('csv_file.csv')

    csv_file.write("member_of_collection_ids,work_type,title,file_name\n")
    csv_file.write("#{collection.id},Generic,My Work 1,#{work_1_file_name}\n")
    csv_file.write("#{collection.id},Generic,My Work 2,#{work_2_file_name}\n")
    csv_file.write("#{collection.id},Generic,My Work 3,#{work_3_file_name}\n")
    csv_file.close

    csv_file
  end

  context 'import a valid csv' do
    it 'displays the dry run of the import with valid works' do
      visit(new_csv_file_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('Total Number of Works with Errors 0')
      within('table') do
        expect(page).to have_selector('th', text: 'Title')
        expect(page).to have_selector('th', text: 'Status')
        expect(page).to have_selector('tr', text: 'My Work 1 Success')
        expect(page).to have_selector('tr', text: 'My Work 2 Success')
        expect(page).to have_selector('tr', text: 'My Work 3 Success')
      end
      click_button('Perform Import')
      expect(page).to have_selector('h1', text: 'Successful Import')
      within('ul.result-list') do
        expect(page).to have_selector('li a', text: 'My Work 1')
        expect(page).to have_selector('li a', text: 'My Work 2')
        expect(page).to have_selector('li a', text: 'My Work 3')
      end
    end
  end
end
