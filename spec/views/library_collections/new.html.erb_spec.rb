# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collection/library_collections/new', type: :view do
  let(:change_set) { Collection::LibraryChangeSet.new(Collection::Library.new) }

  before do
    assign(:collection, change_set)
    render
  end

  it 'renders the new form' do
    assert_select 'form[action=?][method=?]', library_collections_path, 'post' do
      assert_select 'input[name=?]', 'library_collection[title]'
      assert_select 'input[name=?]', 'library_collection[subtitle]'
      assert_select 'input[name=?]', 'library_collection[description]'
      assert_select 'input[name=?]', 'library_collection[workflow]'
      assert_select 'input[name=?]', 'library_collection[visibility]'
      # Added to make sure accessibility changes are in place
      assert_select 'legend', 'Basic Metadata'
      assert_select 'label', 'Title required'
      assert_select 'legend', 'Workflow'
      assert_select 'legend', 'Visibility'
    end
  end
end
