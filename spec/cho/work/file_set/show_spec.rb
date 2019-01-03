# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::FileSet, type: :feature do
  let(:file_set) { create(:file_set, :with_member_file) }

  it 'displays the file set' do
    visit(polymorphic_path([:solr_document], id: file_set.id))
    expect(page).to have_content 'Part of: Sample Generic Work'
    within('div#document') do
      expect(page).to have_blacklight_label('title_tesim').with('Title')
      expect(page).to have_blacklight_field('title_tesim').with('Original File Name')
    end
    expect(page).to have_selector('h2', text: 'Files')
  end
end
