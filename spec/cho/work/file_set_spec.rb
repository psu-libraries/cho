# frozen_string_literal: true

require 'rails_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Work::FileSet do
  let(:resource_klass) { described_class }

  it_behaves_like 'a Valkyrie::Resource'

  describe '#member_ids' do
    its(:member_ids) { is_expected.to be_empty }
  end

  describe '#files' do
    context 'with no files' do
      its(:files) { is_expected.to be_empty }
    end

    context 'with Work::File resources' do
      subject { create(:file_set, :with_member_file) }

      its(:files) { is_expected.to contain_exactly(kind_of(Work::File)) }
    end
  end

  describe '#representative?' do
    subject { file_set }

    context 'when the file set has alternate ids' do
      let(:file_set) { create(:file_set, alternate_ids: ['1']) }

      it { is_expected.not_to be_representative }
    end

    context 'when the file set does not have alternate ids' do
      let(:file_set) { create(:file_set) }

      it { is_expected.to be_representative }
    end
  end

  context 'with an extracted text file' do
    subject { file_set }

    let(:file_set) { create(:file_set) }
    let(:file) { create(:work_file, use: [Valkyrie::Vocab::PCDMUse.ExtractedText]) }

    before { allow(file_set).to receive(:files).and_return([file]) }

    its(:text) { is_expected.to eq(file) }
    its(:preservation) { is_expected.to be_nil }
    its(:preservation_redacted) { is_expected.to be_nil }
    its(:access) { is_expected.to be_nil }
    its(:service) { is_expected.to be_nil }
    its(:thumbnail) { is_expected.to be_nil }
    its(:text_source) { is_expected.to be_nil }
  end

  context 'with a preservation file' do
    subject { file_set }

    let(:file_set) { create(:file_set) }
    let(:file) { create(:work_file, use: [Valkyrie::Vocab::PCDMUse.PreservationMasterFile]) }

    before { allow(file_set).to receive(:files).and_return([file]) }

    its(:text) { is_expected.to be_nil }
    its(:preservation) { is_expected.to eq(file) }
    its(:preservation_redacted) { is_expected.to be_nil }
    its(:access) { is_expected.to be_nil }
    its(:service) { is_expected.to be_nil }
    its(:thumbnail) { is_expected.to be_nil }
    its(:text_source) { is_expected.to eq(file) }
  end

  context 'with a redacted preservation file' do
    subject { file_set }

    let(:file_set) { create(:file_set) }
    let(:file) { create(:work_file, use: [Vocab::FileUse.RedactedPreservationMasterFile]) }

    before { allow(file_set).to receive(:files).and_return([file]) }

    its(:text) { is_expected.to be_nil }
    its(:preservation) { is_expected.to be_nil }
    its(:preservation_redacted) { is_expected.to eq(file) }
    its(:access) { is_expected.to be_nil }
    its(:service) { is_expected.to be_nil }
    its(:thumbnail) { is_expected.to be_nil }
    its(:text_source) { is_expected.to eq(file) }
  end

  context 'with an access file' do
    subject { file_set }

    let(:file_set) { create(:file_set) }
    let(:file) { create(:work_file, use: [Vocab::FileUse.AccessFile]) }

    before { allow(file_set).to receive(:files).and_return([file]) }

    its(:text) { is_expected.to be_nil }
    its(:preservation) { is_expected.to be_nil }
    its(:preservation_redacted) { is_expected.to be_nil }
    its(:access) { is_expected.to eq(file) }
    its(:service) { is_expected.to be_nil }
    its(:thumbnail) { is_expected.to be_nil }
    its(:text_source) { is_expected.to be_nil }
  end

  context 'with a service file' do
    subject { file_set }

    let(:file_set) { create(:file_set) }
    let(:file) { create(:work_file, use: [Valkyrie::Vocab::PCDMUse.ServiceFile]) }

    before { allow(file_set).to receive(:files).and_return([file]) }

    its(:text) { is_expected.to be_nil }
    its(:preservation) { is_expected.to be_nil }
    its(:preservation_redacted) { is_expected.to be_nil }
    its(:access) { is_expected.to be_nil }
    its(:service) { is_expected.to eq(file) }
    its(:thumbnail) { is_expected.to be_nil }
    its(:text_source) { is_expected.to eq(file) }
  end

  context 'with a thumbnail file' do
    subject { file_set }

    let(:file_set) { create(:file_set) }
    let(:file) { create(:work_file, use: [Valkyrie::Vocab::PCDMUse.ThumbnailImage]) }

    before { allow(file_set).to receive(:files).and_return([file]) }

    its(:text) { is_expected.to be_nil }
    its(:preservation) { is_expected.to be_nil }
    its(:preservation_redacted) { is_expected.to be_nil }
    its(:access) { is_expected.to be_nil }
    its(:service) { is_expected.to be_nil }
    its(:thumbnail) { is_expected.to eq(file) }
    its(:text_source) { is_expected.to be_nil }
  end

  context 'with both redacted preservation and preservation files' do
    subject { file_set }

    let(:file_set) { create(:file_set) }
    let(:preservation) { create(:work_file, use: [Valkyrie::Vocab::PCDMUse.PreservationMasterFile]) }
    let(:redacted_preservation) { create(:work_file, use: [Vocab::FileUse.RedactedPreservationMasterFile]) }

    before { allow(file_set).to receive(:files).and_return([preservation, redacted_preservation]) }

    its(:text_source) { is_expected.to eq(redacted_preservation) }
  end
end
