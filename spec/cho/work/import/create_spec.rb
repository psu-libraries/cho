# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preview of CSV Import', type: :feature do
  let(:collection) { create :library_collection, title: 'my collection' }
  let(:work_1_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world.txt') }
  let(:work_2_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world2.txt') }
  let(:work_3_file_name) { Rails.root.join('spec', 'fixtures', 'hello_world3.txt') }

  context 'with a valid csv' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        member_of_collection_ids: [collection.id, collection.id, collection.id],
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', 'My Work 2', 'My Work 3'],
        file_name: [work_1_file_name, work_2_file_name, work_3_file_name]
      )
    end

    it 'successfully imports the csv' do
      visit(csv_create_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('The following new works will be created')
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

  context 'when the csv has invalid columns' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        member_of_collection_ids: [collection.id, collection.id, collection.id],
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', 'My Work 2', 'My Work 3'],
        file_name: [work_1_file_name, work_2_file_name, work_3_file_name],
        invalid_column: ['wrong', 'bad', nil]
      )
    end

    it 'does not perform the dry run' do
      visit(csv_create_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      within('div.alert') do
        expect(page).to have_content("Unexpected column(s): 'invalid_column'")
      end
    end
  end

  context 'when the csv has missing values' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        member_of_collection_ids: [nil, collection.id, collection.id],
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', nil, 'My Work 3'],
        file_name: [work_1_file_name, work_2_file_name, work_3_file_name]
      )
    end

    it 'displays the errors in the dry run page' do
      visit(csv_create_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('Total Number of Works with Errors 2')
      within('table.table') do
        expect(page).to have_content("Member of collection ids can't be blank")
        expect(page).to have_content("Title can't be blank")
      end
    end
  end
end
