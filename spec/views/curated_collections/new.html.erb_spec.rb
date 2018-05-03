# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collection/curated_collections/new', type: :view do
  let(:change_set) { Collection::CuratedChangeSet.new(Collection::Curated.new) }

  before do
    assign(:collection, change_set)
    render
  end

  it 'renders the new form' do
    assert_select 'form[action=?][method=?]', curated_collections_path, 'post' do
      assert_select 'input[name=?]', 'curated_collection[title]'
      assert_select 'input[name=?]', 'curated_collection[subtitle]'
      assert_select 'textarea[name=?]', 'curated_collection[description]'
      assert_select 'input[name=?]', 'curated_collection[workflow]'
      assert_select 'input[name=?]', 'curated_collection[visibility]'
      # Added to make sure accessibility changes are in place
      assert_select 'legend', 'Basic Metadata'
      assert_select 'label', /Title\s.* required/
      assert_select 'legend', 'Workflow'
      assert_select 'legend', 'Visibility'
    end
  end
end
