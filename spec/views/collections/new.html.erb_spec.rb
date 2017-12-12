# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collections/new', type: :view do
  let(:change_set) { CollectionChangeSet.new(Collection.new) }

  before do
    assign(:collection, change_set)
    render
  end

  it 'renders the new form' do
    assert_select 'form[action=?][method=?]', collections_path, 'post' do
      assert_select 'input[name=?]', 'collection[title]'
    end
  end
end
