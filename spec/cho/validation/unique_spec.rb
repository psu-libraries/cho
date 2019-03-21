# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::Unique, type: :model do
  let(:validation_instance) { described_class.new(change_set: change_set, field: field) }

  describe 'validating alternate_ids' do
    let(:field) { :alternate_ids }
    let(:change_set) { Work::SubmissionChangeSet.new(work) }

    context 'when creating a new resource and the alternate id is unique or does not exist' do
      let(:work) { Work::Submission.new }

      it 'is valid' do
        expect(validation_instance.validate('i-am-special')).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'when creating a new resource and the alternate already exists' do
      let(:work) { Work::Submission.new }

      before { create(:work, alternate_ids: 'already-used') }

      it 'is valid' do
        expect(validation_instance.validate('already-used')).to be_falsey
        expect(validation_instance.errors).to contain_exactly('already-used already exists')
      end
    end

    context 'when updating an existing resource and the alternate id is unique or does not exist' do
      let(:work) { create(:work, alternate_ids: ['my-alt-id']) }

      before { change_set.alternate_ids = ['my-updated-alt-id'] }

      it 'is valid' do
        expect(validation_instance.validate('my-updated-alt-id')).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'when updating an existing resource and the id already exists' do
      let(:work) { create(:work, alternate_ids: ['my-alt-id']) }

      before do
        create(:work, alternate_ids: 'my-updated-alt-id')
        change_set.alternate_ids = ['my-updated-alt-id']
      end

      it 'is valid' do
        expect(validation_instance.validate('my-updated-alt-id')).to be_falsey
        expect(validation_instance.errors).to contain_exactly('my-updated-alt-id already exists')
      end
    end

    context 'with a blank id' do
      let(:work) { Work::Submission.new }

      it 'is valid' do
        expect(validation_instance.validate('')).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with a nil id' do
      let(:work) { Work::Submission.new }

      it 'is valid' do
        expect(validation_instance.validate(nil)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end
  end
end
