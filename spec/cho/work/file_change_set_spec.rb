# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Work::FileChangeSet do
  subject(:change_set) { described_class.new(resource) }

  let(:resource) { Work::File.new }

  before { change_set.prepopulate! }

  describe '#append_id' do
    before { change_set.append_id = Valkyrie::ID.new('test') }

    its(:append_id) { is_expected.to eq(Valkyrie::ID.new('test')) }
    its([:append_id]) { is_expected.to eq(Valkyrie::ID.new('test')) }
  end

  describe '#use' do
    it { is_expected.to be_multiple(:use) }
    it { is_expected.to be_required(:use) }
    its(:use) { is_expected.to contain_exactly(Vocab::FileUse.PreservationMasterFile) }
  end

  describe '#original_filename' do
    it { is_expected.not_to be_multiple(:original_filename) }
    it { is_expected.to be_required(:original_filename) }
    its(:original_filename) { is_expected.to be_nil }
  end

  describe '#validate' do
    subject { change_set.errors }

    before do
      change_set.validate(params)
    end

    context 'without an original filename' do
      let(:params) { {} }

      its(:full_messages) { is_expected.to contain_exactly("Original filename can't be blank") }
    end

    context 'with an incorrect use type' do
      let(:params) { { original_filename: 'file.txt', use: ['blarg'] } }

      its(:full_messages) { is_expected.to contain_exactly('Use cannot be blarg') }
    end

    context 'without any use type' do
      let(:params) { { original_filename: 'file.txt', use: [] } }

      its(:full_messages) { is_expected.to contain_exactly('Use cannot be empty') }
    end

    context 'with a nil use type' do
      let(:params) { { original_filename: 'file.txt', use: nil } }

      its(:full_messages) { is_expected.to contain_exactly('Use cannot be empty') }
    end
  end
end
