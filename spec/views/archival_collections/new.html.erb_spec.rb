# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collection/archival_collections/new', type: :view do
  let(:change_set) { Collection::ArchivalChangeSet.new(Collection::Archival.new) }

  before do
    assign(:collection, change_set)
    render
  end

  it 'renders the new form' do
    assert_select 'form[action=?][method=?]', archival_collections_path, 'post' do
      assert_select 'input[name=?]', 'archival_collection[title]'
      assert_select 'input[name=?]', 'archival_collection[subtitle]'
      assert_select 'textarea[name=?]', 'archival_collection[description]'
      assert_select 'input[name=?]', 'archival_collection[workflow]'
      assert_select 'input[name=?]', 'archival_collection[visibility]'
    end
  end
end
