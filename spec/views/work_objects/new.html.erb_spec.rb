# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'work_objects/new', type: :view do
  let(:change_set) { WorkObjectChangeSet.new(WorkObject.new) }

  before do
    assign(:work, change_set)
    render
  end

  it 'renders the new form' do
    assert_select 'form[action=?][method=?]', work_objects_path, 'post' do
      assert_select 'input[name=?]', 'work_object[title]'
    end
  end
end
