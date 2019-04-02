# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataFieldPresenter do
  subject(:presenter) { described_class.new(field: field, document: document) }

  let(:field) { build(:data_dictionary_field, label: 'acknowledgments') }
  let(:value) { ['value'] }
  let(:document) { SolrDocument.new('acknowledgments_tesim' => value) }

  it { is_expected.to delegate_method(:present?).to(:content) }
  it { is_expected.to delegate_method(:blank?).to(:content) }
  it { is_expected.to delegate_method(:label).to(:field) }
  it { is_expected.to delegate_method(:display_transformation).to(:field) }

  describe '#content' do
    its(:content) { is_expected.to contain_exactly('value') }
  end

  describe '#paragraphs' do
    context 'when the field has no content' do
      let(:value) { [] }

      its(:paragraphs) { is_expected.to be_empty }
    end

    context 'when the field has multiple entries and multiple lines' do
      let(:value) do
        [
          "This is the first paragraph.\nThis is the second.",
          "This is the third paragraph.\nThis is the last."
        ]
      end

      its(:paragraphs) do
        is_expected.to contain_exactly(
          'This is the first paragraph.',
          'This is the second.',
          'This is the third paragraph.',
          'This is the last.'
        )
      end
    end
  end
end
