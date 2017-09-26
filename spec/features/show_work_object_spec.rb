# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Showing a work object' do
  # @todo This persists the work in both Postgres and Solr, so we can display it, and then view the
  # edit form. It would be nice if we could build this process into FactoryGirl to make it easier.
  let!(:work) do
    work = nil
    Valkyrie::MetadataAdapter.find(:indexing_persister).persister.buffer_into_index do |buffered_adapter|
      work = buffered_adapter.persister.save(resource: build(:work, title: 'An editable file'))
    end
    work
  end

  it 'displays its show page and links to the edit form' do
    visit(polymorphic_path([:solr_document], id: "id-#{work.id}"))
    expect(page).to have_content('An editable file')
    expect(page).to have_content('Generic')
    click_link('Edit')
    expect(page).to have_field('work_object[title]', with: 'An editable file')
    expect(page).to have_select('work_object[work_type]', with_selected: 'Generic')
  end
end
