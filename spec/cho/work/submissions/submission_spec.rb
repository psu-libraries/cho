# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Work::Submission do
  let(:resource_klass) { described_class }

  it_behaves_like 'a Valkyrie::Resource'
  it_behaves_like 'a resource with Valkyrie::Resource::AccessControls'

  describe '#title' do
    it 'is nil when not set' do
      expect(resource_klass.new.title).to be_empty
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(title: 'test')
      expect(resource.attributes[:title]).to contain_exactly('test')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:title)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:title)
    end
  end

  describe '#work_type_id' do
    it 'is nil when not set' do
      expect(resource_klass.new.work_type_id).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(work_type_id: Valkyrie::ID.new('123'))
      expect(resource.attributes[:work_type_id].to_s).to eq('123')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:work_type_id)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:work_type_id)
    end
  end

  describe '#home_collection_id' do
    it 'is nil when not set' do
      expect(resource_klass.new.home_collection_id).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(home_collection_id: ['1'])
      expect(resource.attributes[:home_collection_id]).to eq(Valkyrie::ID.new('1'))
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:home_collection_id)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:home_collection_id)
    end
  end

  describe '::model_name' do
    context 'with a custom i18n key' do
      subject { described_class.model_name }

      its(:i18n_key) { is_expected.to eq('work') }
      its(:human) { is_expected.to eq('Work') }
    end
  end

  describe '#member_ids' do
    it 'is empty when not set' do
      expect(resource_klass.new.member_ids).to be_empty
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(member_ids: ['1', '2'])
      expect(resource.attributes[:member_ids].map(&:id)).to contain_exactly('1', '2')
      expect(resource.attributes[:member_ids].first.class).to eq(Valkyrie::ID)
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:member_ids)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:member_ids)
    end
  end

  describe '#batch_id' do
    it 'is nil when not set' do
      expect(resource_klass.new.batch_id).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(batch_id: Valkyrie::ID.new('123'))
      expect(resource.attributes[:batch_id].to_s).to eq('123')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:batch_id)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:batch_id)
    end
  end

  describe '#order_index' do
    it 'is nil when not set' do
      expect(resource_klass.new.order_index).to be_nil
    end

    it 'can be set as an attribute' do
      resource = resource_klass.new(order_index: 123)
      expect(resource.attributes[:order_index].to_s).to eq('123')
    end

    it 'is included in the list of attributes' do
      expect(resource_klass.new.has_attribute?(:order_index)).to eq true
    end

    it 'is included in the list of fields' do
      expect(resource_klass.fields).to include(:order_index)
    end
  end

  describe '#file_sets' do
    let(:work)     { create(:work, member_ids: [file_set.id]) }
    let(:file_set) { create(:file_set) }

    it { expect(work.file_sets.map(&:id)).to contain_exactly(file_set.id) }
  end

  describe '#representative_file_set' do
    context 'without a designated representative' do
      let(:work)     { create(:work, member_ids: [file_set.id]) }
      let(:file_set) { create(:file_set) }

      it { expect(work.representative_file_set.id).to eq(file_set.id) }
    end

    context 'with a designated representative' do
      let(:work)           { create(:work, member_ids: [file_set.id, representative.id]) }
      let(:file_set)       { create(:file_set, alternate_ids: ['alt-id']) }
      let(:representative) { create(:file_set, alternate_ids: []) }

      it { expect(work.representative_file_set.id).to eq(representative.id) }
    end

    context 'without any file sets' do
      its(:representative_file_set) { is_expected.to be_a(Work::Submission::NullRepresentativeFileSet) }
    end
  end

  describe '#preservation_file_sets' do
    context 'with no file sets' do
      let(:work) { build(:work) }

      it { expect(work.preservation_file_sets).to be_empty }
    end

    context 'with a single file set' do
      let(:work)     { create(:work, member_ids: [file_set.id]) }
      let(:file_set) { create(:file_set) }

      it { expect(work.preservation_file_sets.map(&:id)).to contain_exactly(file_set.id) }
    end

    context 'with multiple file sets' do
      let(:work)           { create(:work, member_ids: [file_set.id, representative.id]) }
      let(:file_set)       { create(:file_set, alternate_ids: ['alt-id']) }
      let(:representative) { create(:file_set, alternate_ids: []) }

      it { expect(work.preservation_file_sets.map(&:id)).to contain_exactly(file_set.id) }
    end
  end
end
