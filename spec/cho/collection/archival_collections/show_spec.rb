# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection::Archival, type: :feature do
  let(:collection) { create :archival_collection, **MetadataFactory.collection_attributes }

  it 'displays a landing page for the collection' do
    visit(polymorphic_path([:solr_document], id: collection.id))
    expect(page).to have_selector('h1', text: collection.title.first)
    expect(page).to have_selector('p', text: collection.description.first)
    expect(page).to have_selector('img[src$="default-collection-image.png"]')
    expect(page).to have_link('Browse')
    expect(page).to have_link('Finding Aid')
    expect(page).to have_selector('h2', text: 'Collection Information')
    expect(page).to have_selector('legend', text: I18n.t('cho.collection.search.fieldset.legend'))
    expect(page).to have_blacklight_label(:subtitle_tesim)
    expect(page).to have_blacklight_field(:subtitle_tesim).with(collection.subtitle.first)
    expect(page).to have_blacklight_label(:access_rights_tesim)
    expect(page).to have_blacklight_field(:access_rights_tesim).with(Repository::AccessControls::AccessLevel.public)
  end

  context 'with a Penn State collection' do
    let(:resource) { create(:psu_collection) }

    it_behaves_like 'a resource restricted to Penn State users'
  end

  context 'with a restricted collection' do
    let(:restricted_user) { create(:user) }
    let(:resource) do
      create(:private_collection,
             system_creator: restricted_user.login,
             read_users: [restricted_user.login])
    end

    it_behaves_like 'a restricted resource', with_user: :restricted_user
  end

  it_behaves_like 'a collection editable only by admins'
end
