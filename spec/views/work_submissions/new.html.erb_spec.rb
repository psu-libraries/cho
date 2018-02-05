# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'work/submissions/new', type: :view do
  let(:change_set) { Work::SubmissionChangeSet.new(Work::Submission.new) }

  before do
    assign(:work, change_set)
    render
  end

  it 'renders the new form' do
    assert_select 'form[action=?][method=?]', works_path, 'post' do
      assert_select 'input[name=?]', 'work_submission[title]'
    end
  end
end
