# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'work/submissions/edit', type: :view do
  let(:work) { build(:work, title: ['Editable title'], id: 'id', work_type_id: work_type.id) }
  let(:work_type)  { Work::Type.where(label: 'Document').first }
  let(:change_set) { Work::SubmissionChangeSet.new(work) }
  let(:form) { change_set }

  before do
    @work = assign(:work, form)
    render
  end

  it 'renders the edit form' do
    assert_form('document_field')
  end

  it 'renders the delete form' do
    assert_select 'form[action=?][method=?]', batch_delete_path, 'post' do
      assert_select 'input[type=hidden][name=?][value=?]', 'delete[ids][]', 'id'
    end
  end

  context 'Map type' do
    let(:work_type)  { Work::Type.where(label: 'Map').first }

    it 'renders the edit form' do
      assert_form('map_field')
    end
  end

  context 'Still Image type' do
    let(:work_type) { Work::Type.where(label: 'Still Image').first }

    it 'renders the edit form' do
      assert_form('still_image_field', 'Photograph')
    end
  end

  context 'Generic type' do
    let(:work_type) { Work::Type.where(label: 'Generic').first }

    it 'renders the edit form' do
      assert_form('generic_field')
    end
  end

  context 'Moving Image type' do
    let(:work_type) { Work::Type.where(label: 'Moving Image').first }

    it 'renders the edit form' do
      assert_form('moving_image_field')
    end
  end

  context 'Audio type' do
    let(:work_type) { Work::Type.where(label: 'Audio').first }

    it 'renders the edit form' do
      assert_form('audio_field', 'Audio Field', 'Additional Info')
    end
  end

  def assert_form(specific_field, display_label = nil, subtitle_label = nil)
    display_label ||= specific_field.titleize
    subtitle_label ||= 'Subtitle'
    assert_select 'form[action=?][method=?]', work_path(@work.model), 'post' do
      assert_select 'label[for=?]', 'work_submission_title', text: "Object Title\n       required"
      assert_select 'input[name=?]', 'work_submission[title]'
      assert_select 'label[for=?]', 'work_submission_subtitle', text: subtitle_label
      assert_select 'input[name=?]', 'work_submission[subtitle]'
      assert_select 'label[for=?]', 'work_submission_description', text: 'Description'
      assert_select 'textarea[name=?]', 'work_submission[description]'
      assert_select 'label[for=?]', "work_submission_#{specific_field}", text: display_label
      assert_select 'input[name=?]', "work_submission[#{specific_field}]"
    end
  end
end
