# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'work/submissions/new', type: :view do
  let(:work_type)  { Work::Type.where(label: 'Document').first }
  let(:change_set) { Work::SubmissionChangeSet.new(Work::Submission.new(work_type_id: work_type.id)) }
  let(:form) { change_set }

  before do
    assign(:work, form)
    render
  end

  it 'renders the new form' do
    assert_select 'form[action=?][method=?]', works_path, 'post' do
      assert_select 'input[name=?]', 'work_submission[title]'
      assert_select 'input[name=?]', 'work_submission[member_of_collection_ids][]'
      assert_select 'label', 'File Selection'
    end
  end
end
