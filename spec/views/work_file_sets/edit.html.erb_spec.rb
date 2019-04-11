# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'work/file_sets/edit', type: :view do
  let(:file_set) { create(:file_set, title: ['Editable file set']) }
  let(:change_set) { Work::FileSetChangeSet.new(file_set) }
  let(:form) { change_set }

  before do
    controller.request.path_parameters[:id] = file_set.id.to_s
    @file_set = assign(:file_set, form)
    render
  end

  it 'renders the form' do
    assert_select 'form[action=?][method=?]', file_set_path(file_set), 'post' do
      assert_select 'label[for=?]', 'work_file_set_title', text: /(\s*)required/
      assert_select 'input[name=?]', 'work_file_set[title]'
      assert_select 'label[for=?]', 'work_file_set_subtitle'
      assert_select 'input[name=?]', 'work_file_set[subtitle][]'
      assert_select 'label[for=?]', 'work_file_set_description'
      assert_select 'textarea[name=?]', 'work_file_set[description][]'
    end
    assert_select 'a[href=?]', "/catalog/#{file_set.id}"
  end
end
