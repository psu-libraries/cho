# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collection/archival_collections/edit', type: :view do
  let(:collection) { build(:archival_collection, title: ['Editable title'], id: 'id') }
  let(:change_set) { Collection::ArchivalChangeSet.new(collection) }

  before do
    @collection = assign(:collection, change_set)
    render
  end

  it 'renders the edit form' do
    assert_select 'form[action=?][method=?]', archival_collection_path(@collection), 'post' do
      assert_select 'input[name=?]', 'archival_collection[title]'
      assert_select 'input[name=?]', 'archival_collection[subtitle][]'
      assert_select 'textarea[name=?]', 'archival_collection[description][]'
      assert_select 'input[name=?]', 'archival_collection[workflow]'
      assert_select 'input[name=?]', 'archival_collection[access_level]'
      # Added to make sure accessibility changes are in place
      assert_select 'legend', 'Basic Metadata'
      assert_select 'label[for=?]', 'archival_collection_title', text: /\s.* required/
      assert_select 'legend', 'Workflow'
      assert_select 'legend', 'Access Level'
    end
    assert_select 'form[action=?]', "/catalog/#{collection.id}"
  end
end
