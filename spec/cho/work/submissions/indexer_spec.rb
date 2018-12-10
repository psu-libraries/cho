# frozen_string_literal: true

require 'rails_helper'

describe Work::SubmissionIndexer do
  let(:indexer) { described_class.new(resource: resource) }

  describe '#to_solr' do
    subject { indexer.to_solr }

    context "when the resource doesn't have a work type" do
      let(:resource) { instance_double('Resource') }

      it { is_expected.to be_empty }
    end

    context "when the resource's work type is nil" do
      let(:resource) { instance_double(Work::Submission, work_type_id: nil) }

      it { is_expected.to be_empty }
    end

    context "when the resource's work type isn't an id or doesn't exist" do
      let(:resource) { create(:work, work_type_id: "I don't exist") }

      it { is_expected.to include(work_type_ssim: nil) }
    end

    context "when the resource's work type does exist" do
      let(:work_type) { create :work_type, label: 'Indexed Label' }
      let(:resource)  { create(:work, work_type_id: work_type.id) }

      it { is_expected.to include(work_type_ssim: 'Indexed Label') }
    end

    context "When the resource's collection id is present" do
      let(:work_type)  { create :work_type, label: 'Indexed Label' }
      let(:collection) { create :library_collection, title: 'My Collection' }
      let(:resource)   { create(:work, work_type_id: work_type.id, member_of_collection_ids: [collection.id]) }

      it { is_expected.to include(work_type_ssim: 'Indexed Label', member_of_collection_ssim: ['My Collection']) }
    end
  end
end
