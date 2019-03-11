# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::Download, type: :model do
  describe '#available?' do
    subject { described_class.new(id: file_set.id) }

    context 'when the file set has a file that is present on the system' do
      let(:file_set) { create(:file_set, :with_member_file) }

      it { is_expected.to be_available }
    end

    context 'when the file in the file set is missing from the system' do
      let(:file_set) { create(:file_set, :with_missing_file) }

      it { is_expected.not_to be_available }
    end

    context 'when the file does not have a file' do
      let(:file_set) { create(:file_set) }

      it { is_expected.not_to be_available }
    end
  end

  describe '#path' do
    subject { described_class.new(id: 'id') }

    it { is_expected.to delegate_method(:path).to(:file) }
  end

  describe '#file' do
    subject { described_class.new(id: file_set.id) }

    let(:file_set) { create(:file_set, :with_member_file) }

    its(:file) { is_expected.to be_kind_of(Work::File) }
  end
end
