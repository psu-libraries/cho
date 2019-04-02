# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Curated, type: :feature do
  context 'when filling in all the required fields' do
    it 'creates a new curated collection' do
      visit(new_curated_collection_path)
      fill_in('curated_collection[title]', with: 'New Title')
      fill_in('curated_collection[subtitle]', with: 'new subtitle')
      fill_in('curated_collection[description]', with: 'Description of new collection')
      choose('Mediated')
      choose('PSU Access')
      click_button('Create Curated collection')
      expect(page).to have_content('New Title')
      expect(page).to have_content('new subtitle')
      expect(page).to have_content('Description of new collection')
      expect(page).to have_content('mediated')
      expect(page).to have_content('authenticated')
    end
  end

  context 'without providing the required metadata' do
    before { create(:collection, alternate_ids: 'existing-id') }

    it 'reports the errors' do
      visit(new_curated_collection_path)
      fill_in('curated_collection[alternate_ids]', with: 'existing-id')
      click_button('Create Curated collection')
      expect(page).to have_content("Object title can't be blank")
      expect(page).to have_content('Identifier existing-id already exists')
    end
  end

  context 'when filling in all the collection metadata' do
    let!(:agent) { create(:agent, :generate_name) }
    let(:title) { Faker::Company.name }
    let(:subtitle) { Faker::Hipster.sentence }
    let(:description) { Faker::Hipster.sentence }
    let(:identifier) { Faker::Number.leading_zero_number(10) }
    let(:acknowledgments) { 'Acknowledgmentium ' + Faker::Lorem.paragraph }
    let(:narrative) { 'Narratismus ' + Faker::Lorem.paragraph }

    it 'creates a new curated collection' do
      visit(new_curated_collection_path)
      fill_in('curated_collection[title]', with: title)
      fill_in('curated_collection[subtitle]', with: subtitle)
      fill_in('curated_collection[description]', with: description)
      fill_in('curated_collection[alternate_ids]', with: identifier)
      fill_in('curated_collection[acknowledgments]', with: acknowledgments)
      fill_in('curated_collection[narrative]', with: narrative)
      select(agent, from: 'curated_collection[creator][agent]')
      select('blasting', from: 'curated_collection[creator][role]')
      choose('Mediated')
      choose('PSU Access')
      click_button('Create Curated collection')
      expect(page).to have_content(title)
      expect(page).to have_content(subtitle)
      expect(page).to have_content(description)
      expect(page).to have_content(identifier)
      expect(page).to have_content("#{agent.display_name}, blasting")
      expect(page).to have_selector('h2', text: 'Acknowledgments')
      expect(page).to have_content(acknowledgments)
      expect(page).to have_content(narrative)
    end
  end
end
