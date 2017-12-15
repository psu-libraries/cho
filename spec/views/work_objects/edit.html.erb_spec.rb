# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'work_object/deposits/edit', type: :view do
  let(:work) { build(:work, title: ['Editable title'], id: 'id') }
  let(:change_set) { WorkObject::ChangeSet.new(work) }

  before do
    @work = assign(:work, change_set)
    render
  end

  it 'renders the edit form' do
    assert_select 'form[action=?][method=?]', work_object_path(@work), 'post' do
      assert_select 'input[name=?]', 'work_object_deposit[title]'
    end
  end
end
