# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repository::AccessLevel do
  describe '::uris' do
    specify do
      expect(described_class.uris).to contain_exactly(
        Vocab::AccessLevel.Public,
        Vocab::AccessLevel.PennState,
        Vocab::AccessLevel.Restricted
      )
    end
  end

  describe '::names' do
    specify do
      expect(described_class.names).to contain_exactly(
        'public',
        'registered',
        'private'
      )
    end
  end

  describe '::public' do
    subject { described_class.public }

    it { is_expected.to eq('public') }
  end

  describe '::penn_state' do
    subject { described_class.penn_state }

    it { is_expected.to eq('registered') }
  end

  describe '::restricted' do
    subject { described_class.restricted }

    it { is_expected.to eq('private') }
  end
end
