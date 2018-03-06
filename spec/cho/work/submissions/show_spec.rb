# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Submission, type: :feature do
  let(:work_type) { Work::Type.where(label: 'Document').first }

  context 'when the work has no files' do
    let(:collection) { create_for_repository(:library_collection) }
    let(:work) do create_for_repository(:work,
      title: 'No files',
      member_of_collection_ids: [collection.id],
      work_type: work_type.id)
    end

    it 'displays only metadata' do
      visit(polymorphic_path([:solr_document], id: work.id))
      within('div#document') do
        expect(page).to have_blacklight_label('title_tesim').with('Title')
        expect(page).to have_blacklight_field('title_tesim').with('No files')
        expect(page).to have_blacklight_label('work_type_ssim').with('Work Type')
        expect(page).to have_blacklight_field('work_type_ssim').with('Document')
        expect(page).to have_blacklight_label('member_of_collections_ssim').with('Collections')
        expect(page).to have_blacklight_field('member_of_collections_ssim').with('Library Collection')
        expect(page).to have_link('Library Collection')
      end
      expect(page).not_to have_selector('h2', text: 'Files')
    end
  end

  context 'when the work has a file' do
    let(:work) { create_for_repository(:work, :with_file, title: 'An editable file', work_type: work_type.id) }

    it 'displays metadata and files' do
      visit(polymorphic_path([:solr_document], id: work.id))
      within('div#document') do
        expect(page).to have_blacklight_label('title_tesim').with('Title')
        expect(page).to have_blacklight_field('title_tesim').with('An editable file')
        expect(page).to have_blacklight_label('work_type_ssim').with('Work Type')
        expect(page).to have_blacklight_field('work_type_ssim').with('Document')
      end
      expect(page).to have_selector('h2', text: 'Files')
      expect(page).to have_content('hello_world.txt')
      click_link('Edit')
      expect(page).to have_field('work_submission[title]', with: 'An editable file')
      expect(page).not_to have_select('work_submission[work_type]', with_selected: 'Generic')
    end
  end
end
