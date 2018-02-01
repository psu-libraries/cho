# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collection/curated_collections/edit', type: :view do
  let(:collection) { build(:curated_collection, title: ['Editable title'], id: 'id') }
  let(:change_set) { Collection::CuratedChangeSet.new(collection) }

  before do
    @collection = assign(:collection, change_set)
    render
  end

  it 'renders the edit form' do
    assert_select 'form[action=?][method=?]', curated_collection_path(@collection), 'post' do
      assert_select 'input[name=?]', 'curated_collection[title]'
      assert_select 'input[name=?]', 'curated_collection[subtitle]'
      assert_select 'textarea[name=?]', 'curated_collection[description]'
      assert_select 'input[name=?]', 'curated_collection[workflow]'
      assert_select 'input[name=?]', 'curated_collection[visibility]'
    end
  end
end
