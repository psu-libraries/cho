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
      let(:resource) { instance_double('Resource', work_type: nil) }

      it { is_expected.to be_empty }
    end

    context "when the resource's work type isn't an id or doesn't exist" do
      let(:resource) { instance_double('Resource', work_type_id: "I don't exist") }

      it { is_expected.to eq(work_type_ssim: "I don't exist") }
    end

    context "when the resource's work type does exist" do
      let(:work_type) { create :work_type, label: 'Indexed Label' }
      let(:resource) { instance_double('Resource', work_type_id: work_type.id) }

      it { is_expected.to eq(work_type_ssim: 'Indexed Label') }
    end
  end
end
