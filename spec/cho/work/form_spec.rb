# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::Form do
  subject { described_class.new(change_set) }

  let(:change_set) { Work::SubmissionChangeSet.new(work).prepopulate! }
  let(:work) { Work::Submission.new(work_type: work_type.id) }
  let(:work_type) { Work::Type.find_using(label: 'Generic').first }

  describe '#model' do
    its(:model) { is_expected.to eq(work) }
    its(:work_type) { is_expected.to eq(work_type) }
  end

  describe '#fields' do
    subject(:fields) { described_class.new(change_set).fields }

    let(:work_field) { Schema::MetadataField.find_using(label: 'generic_field').first }

    its(:count) { is_expected.to eq(4) }

    it 'is ordered' do
      expect(fields.map(&:label)).to eq(['title', 'subtitle', 'description', 'generic_field'])
    end

    context 'fields are reordered' do
      before do
        work_field.order_index = -1
        Valkyrie.config.metadata_adapter.persister.save(resource: work_field)
      end

      it 'is ordered' do
        expect(fields.map(&:label)).to eq(['generic_field', 'title', 'subtitle', 'description'])
      end
    end
  end

  describe '#submit_text' do
    its(:submit_text) { is_expected.to eq('Create Work') }

    context 'save work' do
      let(:unsaved_work) { Work::Submission.new(work_type: work_type.id) }
      let(:work) { Valkyrie.config.metadata_adapter.persister.save(resource: unsaved_work) }

      its(:submit_text) { is_expected.to eq('Update Work') }
    end
  end

  describe '#form_path' do
    its(:form_path) { is_expected.to eq('/works') }

    context 'save work' do
      let(:unsaved_work) { Work::Submission.new(work_type: work_type.id) }
      let(:work) { Valkyrie.config.metadata_adapter.persister.save(resource: unsaved_work) }

      its(:form_path) { is_expected.to eq("/works/#{work.id}") }
    end
  end
end
