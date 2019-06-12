# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Works with multiple fields', with_named_js: :multiple_fields, type: :feature do
  context 'when adding new fields for entry' do
    def check_field(label:)
      within(".ff-multiple.#{label}") do
        expect(page).to have_css('.ff-add', text: /\(\+\) Add another/)
        expect(page).to have_selector('span.ff-remove', text: '(-) Remove', count: 1, visible: false)
        retry_click { find('.ff-add').click }
        expect(page).to have_selector('span.ff-remove', text: '(-) Remove', count: 2, visible: true)
        page.all('.ff-remove').last.click
        expect(page).to have_selector('span.ff-remove', text: '(-) Remove', count: 1, visible: false)
      end
    end

    it 'inserts new inputs with remove links' do
      visit(root_path)
      click_link('Create Resource')
      click_link('Generic')
      expect(page).to have_content('New Generic Resource', wait: Capybara.default_max_wait_time * 5)
      check_field(label: 'subtitle')
      check_field(label: 'description')
      check_field(label: 'alternate_ids')
      check_field(label: 'creator')
      check_field(label: 'generic_field')
      check_field(label: 'created')
      within('.ff-single.home_collection_id') do
        expect(page).not_to have_selector('span.ff-remove')
        expect(page).not_to have_selector('span.ff-add')
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
      within(".ff-multiple.#{field}") do
        fill_in("work_submission[#{field}][]", with: attributes1[field])
        retry_click { find('.ff-add').click }
        expect(page.all('.ff-control').last.value).to be_empty
        page.all('.ff-control').last.set(attributes2[field])
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
      within('.ff-multiple.creator') do
        fill_in('work_submission[creator][][role]', with: MockRDF.relators.first)
        fill_in('work_submission[creator][][agent]', with: agent1.id)
        retry_click { find('.ff-add').click }
        inputs = page.all('.ff-control')
        expect(inputs[2].value).to be_empty
        expect(inputs[3].value).to be_empty
        inputs[2].set(MockRDF.relators.last)
        inputs[3].set(agent2.id)
      end

      fill_in('work_submission[home_collection_id]', with: archival_collection.id)
      retry_click { click_button('Create Resource') }
      verify_multiple(:subtitle)
      verify_multiple(:description)
      verify_multiple(
        :alternate_ids,
        content: "id-#{attributes1[:alternate_ids]} and id-#{attributes2[:alternate_ids]}"
      )
      verify_multiple(:generic_field)
      verify_multiple(:created)
      verify_multiple(
        :creator,
        content:
          "#{agent1.display_name}, #{MockRDF.relators.first.label} and " \
          "#{agent2.display_name}, #{MockRDF.relators.last.label}"
      )
    end
  end
end
