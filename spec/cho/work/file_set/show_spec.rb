# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::FileSet, type: :feature do
  let(:file_set) { create(:file_set, :with_member_file) }

  it 'displays the file set' do
    visit(polymorphic_path([:solr_document], id: file_set.id))
    expect(page).to have_content 'Part of: Sample Generic Work'
    within('div#document') do
      expect(page).to have_blacklight_label('title_tesim')
      expect(page).to have_blacklight_field('title_tesim').with('Original File Name')
    end
    expect(page).to have_selector('h2', text: 'Files')
  end

  context 'with a Penn State file set' do
    let(:resource) { create(:preservation_file_set, :restricted_to_penn_state) }

    it_behaves_like 'a resource restricted to Penn State users'
  end

  context 'with a restricted file set' do
    let(:restricted_user) { create(:user) }
    let(:resource) do
      create(:file_set, :restricted, system_creator: restricted_user.login, read_users: [restricted_user.login])
    end

    it_behaves_like 'a restricted resource', with_user: :restricted_user
  end
end
