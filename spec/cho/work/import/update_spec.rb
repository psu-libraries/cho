# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preview of CSV Update', type: :feature do
  context 'with a valid csv' do
    let(:csv_file) do
      CsvFactory::Update.new(
        { title: 'My Updated Work 1' },
        { title: 'My Updated Work 2' },
        title: 'My Updated Work 3'
      )
    end

    it 'successfully updates the works' do
      visit(csv_update_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      expect(page).to have_content('Import a csv that updates existing works')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('The following works will be updated')
      expect(page).to have_content('Total Number of Works with Errors 0')
      within('table') do
        expect(page).to have_selector('th', text: 'Title')
        expect(page).to have_selector('th', text: 'Status')
        expect(page).to have_selector('tr', text: 'My Updated Work 1 Success')
        expect(page).to have_selector('tr', text: 'My Updated Work 2 Success')
        expect(page).to have_selector('tr', text: 'My Updated Work 3 Success')
      end
      click_button('Perform Import')
      expect(page).to have_selector('h1', text: 'Successful Import')
      within('ul.result-list') do
        expect(page).to have_selector('li a', text: 'My Updated Work 1')
        expect(page).to have_selector('li a', text: 'My Updated Work 2')
        expect(page).to have_selector('li a', text: 'My Updated Work 3')
      end
    end
  end

  context 'when the csv has a missing id column' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        work_type: ['Generic', 'Generic', 'Generic'],
        title: ['My Work 1', 'My Work 2', 'My Work 3']
      )
    end

    it 'does not perform the dry run' do
      visit(csv_update_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      within('div.alert') do
        expect(page).to have_content('Missing id column for update')
      end
    end
  end

  context 'when the csv has missing values' do
    let(:csv_file) do
      CsvFactory::Update.new(
        { title: 'My Updated Work 1' },
        { title: nil },
        title: 'My Updated Work 3'
      )
    end

    it 'displays the errors in the dry run page' do
      visit(csv_update_path)
      expect(page).to have_selector('h1', text: 'CSV Import')
      attach_file('work_import_csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('Total Number of Works with Errors 1')
      within('table.table') do
        expect(page).to have_content("Title can't be blank")
      end
    end
  end
end
