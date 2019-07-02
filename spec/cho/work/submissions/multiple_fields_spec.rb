# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Works with multiple fields', with_named_js: :multiple_fields, type: :feature do
  def parent_div(field)
    find("label[for='work_submission_#{field}']").first(:xpath, './/..')
  end

  context 'when adding new fields for entry' do
    def check_field(field, label: nil)
      label ||= field.to_s.titleize
      within(parent_div(field)) do
        expect(page).to have_selector('button', text: /Add another/)
        expect(page).not_to have_selector('button', text: 'Remove')
        expect(page).to have_selector('div', class: 'input-group', count: 1)
        retry_click { click_button(label) }
        expect(page).to have_selector('div', class: 'input-group', count: 2)
        retry_click { click_button('Remove') }
        expect(page).to have_selector('div', class: 'input-group', count: 1)
      end
    end

    it 'inserts new inputs with remove links' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource', wait: Capybara.default_max_wait_time * 5)
      check_field(:subtitle)
      check_field(:description)
      check_field(:alternate_ids, label: 'Identifier')
      check_field(:creator)
      check_field(:generic_field)
      check_field(:created)
      within(parent_div(:home_collection_id)) do
        expect(page).not_to have_selector('button', text: /Add another/)
        expect(page).not_to have_selector('button', text: 'Remove')
      end
    end
  end

  context 'when entering information into multiple fields' do
    let!(:archival_collection) { create(:archival_collection, title: 'Sample Collection') }
    let!(:attributes1) { MetadataFactory.collection_attributes }
    let!(:attributes2) { MetadataFactory.collection_attributes }
    let!(:agent1) { create(:agent, :generate_name) }
    let!(:agent2) { create(:agent, :generate_name) }

    def fill_in_multiple(field)
      within(parent_div(field)) do
        fill_in("work_submission[#{field}][]", with: attributes1[field])
        retry_click { find('button').click }
        expect(page.all('.form-control').last.value).to be_empty
        page.all('.form-control').last.set(attributes2[field])
      end
    end

    def verify_multiple(field, content: nil)
      content ||= "#{attributes1[field]} and #{attributes2[field]}"
      expect(page).to have_selector("dd.blacklight-#{field}_tesim", text: content)
    end

    it 'updates each field with the new information' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource', wait: Capybara.default_max_wait_time * 5)
      fill_in('work_submission[title]', with: 'New Title')
      fill_in_multiple(:subtitle)
      fill_in_multiple(:description)
      fill_in_multiple(:alternate_ids)
      fill_in_multiple(:generic_field)
      fill_in_multiple(:created)

      # Add multiple creators
      within(parent_div(:creator)) do
        expect(page).to have_selector('.input-group-text', text: 'Select')
        fill_in('work_submission[creator][][role]', with: MockRDF.relators.first)
        fill_in('work_submission[creator][][agent]', with: agent1.id)
        expect(page).to have_selector('.input-group-text', text: agent1)
        retry_click { click_button('Add another Creator') }
        inputs = page.all('.form-control')
        spans = page.all('.input-group-text')
        expect(inputs[2].value).to be_empty
        expect(inputs[3].value).to be_empty
        expect(spans[1]).to have_text('Select')
        inputs[2].set(agent2.id)
        inputs[3].set(MockRDF.relators.last)
        expect(spans[1]).to have_text(agent2.to_s)
      end

      within(parent_div(:home_collection_id)) do
        expect(page).to have_selector('.input-group-text', text: 'Select')
        fill_in('work_submission[home_collection_id]', with: archival_collection.id)
        expect(page).to have_selector('.input-group-text', text: archival_collection.title.first)
      end

      retry_click { click_button('Create Resource') }

      verify_multiple(:subtitle)
      verify_multiple(:description)
      verify_multiple(
        :alternate_ids,
        content: "id-#{attributes1[:alternate_ids]} and id-#{attributes2[:alternate_ids]}"
      )
      verify_multiple(:generic_field)
      verify_multiple(
        :created,
        content: [attributes1, attributes2].map { |a| a[:created].humanize }.join(', ')
      )
      verify_multiple(
        :creator,
        content:
          "#{agent1.display_name}, #{MockRDF.relators.first.label} and " \
          "#{agent2.display_name}, #{MockRDF.relators.last.label}"
      )
    end
  end
end
