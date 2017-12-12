# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collections/edit', type: :view do
  let(:collection) { build(:collection, title: ['Editable title'], id: 'id') }
  let(:change_set) { CollectionChangeSet.new(collection) }

  before do
    @collection = assign(:collection, change_set)
    render
  end

  it 'renders the edit form' do
    assert_select 'form[action=?][method=?]', collection_path(@collection), 'post' do
      assert_select 'input[name=?]', 'collection[title]'
    end
  end
end
