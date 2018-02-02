# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'work/submissions/edit', type: :view do
  let(:work) { build(:work, title: ['Editable title'], id: 'id') }
  let(:change_set) { Work::SubmissionChangeSet.new(work) }

  before do
    @work = assign(:work, change_set)
    render
  end

  it 'renders the edit form' do
    assert_select 'form[action=?][method=?]', work_path(@work), 'post' do
      assert_select 'input[name=?]', 'work_submission[title]'
    end
  end
end
