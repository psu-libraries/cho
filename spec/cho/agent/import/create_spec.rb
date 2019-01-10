# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Preview of CSV Agent Import', type: :feature do
  context 'with a valid csv' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        given_name: ['John', 'Jane'],
        surname: ['Doe', 'Smith']
      )
    end

    it 'successfully imports the csv' do
      visit(csv_agents_create_path)
      expect(page).to have_selector('h1', text: 'CSV Agent Import')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Import Preview')
      expect(page).to have_selector('h2', text: 'CSV Status')
      expect(page).to have_content('The following new agents will be created')
      expect(page).to have_content('Total Number of Agents with Errors 0')
      within('table') do
        expect(page).to have_selector('th', text: 'Given Name')
        expect(page).to have_selector('th', text: 'Surname')
        expect(page).to have_selector('th', text: 'Status')
        expect(page).to have_selector('tr', text: 'John Doe Success')
        expect(page).to have_selector('tr', text: 'Jane Smith Success')
      end
      click_button('Perform Import')
      expect(page).to have_selector('h1', text: 'Successful Import')
      within('ul.result-list') do
        expect(page).to have_selector('li a', text: 'John Doe')
        expect(page).to have_selector('li a', text: 'Jane Smith')
      end

      # Verify each work has a file set and a file
      expect(Agent::Resource.all.map(&:surname)).to contain_exactly('Doe', 'Smith')
    end
  end

  context 'when the csv has invalid columns' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        given_name: ['John', 'Jane'],
        surname: ['Doe', 'Smith'],
        invalid_column: ['wrong', 'bad']
      )
    end

    it 'does not perform the dry run' do
      visit(csv_agents_create_path)
      expect(page).to have_selector('h1', text: 'CSV Agent Import')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      within('div.alert') do
        expect(page).to have_content("Unexpected column(s): 'invalid_column'")
      end
    end
  end

  context 'when the csv has errors' do
    let(:csv_file) do
      CsvFactory::Generic.new(
        given_name: ['', 'Jane', 'Thomas'],
        surname: ['Doe', '', 'Anderson']
      )
    end

    before { create(:agent, given_name: 'Thomas', surname: 'Anderson') }

    it 'displays the errors in the dry run page' do
      visit(csv_agents_create_path)
      expect(page).to have_selector('h1', text: 'CSV Agent Import')
      attach_file('csv_file_file', csv_file.path)
      click_button('Preview Import')
      expect(page).to have_selector('h1', text: 'Agent Import Preview')
      expect(page).to have_content('Total Number of Agents with Errors 3')
      within('table.table') do
        expect(page).to have_content("Given name can't be blank")
        expect(page).to have_content("Surname can't be blank")
        expect(page).to have_content('Thomas Anderson already exists')
      end
    end
  end
end
