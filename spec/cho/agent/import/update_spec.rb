# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preview of CSV Agent Update', type: :feature do
  context 'with a valid csv' do
    let(:csv_file) do
      CsvFactory::AgentUpdate.new(
        { given_name: 'Huey', surname: 'Duck' },
        { given_name: 'Duey', surname: 'Duck' },
        given_name: 'Louis', surname: 'Duck'
      )
    end

    it 'successfully updates the works' do
      visit(csv_agents_update_path)
      expect(page).to have_selector('h1', text: 'CSV Agent Import')
      expect(page).to have_content('Import a CSV that updates existing agents')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('The following agents will be updated')
      expect(page).to have_content('Total Number of Agents with Errors 0')
      within('table') do
        expect(page).to have_selector('th', text: 'Given Name')
        expect(page).to have_selector('th', text: 'Surname')
        expect(page).to have_selector('th', text: 'Status')
        expect(page).to have_selector('tr', text: 'Huey Duck Success')
        expect(page).to have_selector('tr', text: 'Duey Duck Success')
        expect(page).to have_selector('tr', text: 'Louis Duck Success')
      end
      click_button('Perform Import')
      expect(page).to have_selector('h1', text: 'Successful Import')
      within('ul.result-list') do
        expect(page).to have_selector('li a', text: 'Huey Duck')
        expect(page).to have_selector('li a', text: 'Duey Duck')
        expect(page).to have_selector('li a', text: 'Louis Duck')
      end
    end
  end

  context 'when the csv has a missing id column' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        given_name: ['John', 'Jane'],
        surname: ['Doe', 'Smith']
      )
    end

    it 'does not perform the dry run' do
      visit(csv_agents_update_path)
      expect(page).to have_selector('h1', text: 'CSV Agent Import')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      within('div.alert') do
        expect(page).to have_content('Missing id column for update')
      end
    end
  end

  context 'when the csv has errors' do
    let(:csv_file) do
      CsvFactory::AgentUpdate.new(
        { given_name: 'Huey', surname: 'Duck' },
        { given_name: '', surname: 'Duck' },
        { given_name: 'Louis', surname: 'Duck' },
        given_name: 'Thomas', surname: 'Anderson'
      )
    end

    before { create(:agent, given_name: 'Thomas', surname: 'Anderson') }

    it 'displays the errors in the dry run page' do
      visit(csv_agents_update_path)
      expect(page).to have_selector('h1', text: 'CSV Agent Import')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_content('Total Number of Agents with Errors 2')
      within('table.table') do
        expect(page).to have_content("Given name can't be blank")
        expect(page).to have_content('Thomas Anderson already exists')
      end
    end
  end
end
