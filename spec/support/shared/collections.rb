# frozen_string_literal: true

RSpec.shared_examples 'a collection with works' do
  before do
    (1..20).each do |count|
      create_for_repository(:work, title: "Work #{count}", member_of_collection_ids: [collection.id])
    end
  end

  it 'displays a paginated listing of its works' do
    visit(polymorphic_path([:solr_document], id: collection.id))
    expect(page).to have_content('Items in this Collection')
    within('div#members') do
      expect(page).to have_link('Work 1')
      expect(page).not_to have_link('Work 20')
    end
    within('div.pagination') do
      expect(page).to have_link('2')
      click_link('Next')
    end
    within('div#members') do
      expect(page).not_to have_link('Work 5')
      expect(page).to have_link('Work 20')
    end
  end
end
