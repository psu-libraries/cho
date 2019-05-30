# frozen_string_literal: true

require 'spec_helper'
require 'rspec/its'
require 'active_support/core_ext/module/delegation'
require_relative '../../../app/cho/indexing/solr_searchable_field'

RSpec.describe Indexing::SolrSearchableField do
  subject(:searchable_field) { described_class.new(dd_field) }

  let(:dd_field) { instance_spy('DataDictionary::Field', label: 'field_label') }

  describe '#initialize' do
    context 'given something besides a DD::Field' do
      let(:not_dd_field) { "I'm a string!" }

      it 'raises' do
        expect { described_class.new(not_dd_field) }
          .to raise_error(ArgumentError)
      end
    end
  end

  its(:label) { is_expected.to eq 'field_label' }
  its(:qf) { is_expected.to eq 'field_label_tesim' }
  its(:pf) { is_expected.to eq 'field_label_tesim' }
  its(:solr_search_params) { is_expected.to eq(qf: 'field_label_tesim', pf: 'field_label_tesim') }

  context 'given an EDTF date field' do
    before do
      allow(dd_field).to receive(:date?).and_return(true)
      allow(dd_field).to receive(:validation).and_return('edtf_date')
    end

    let(:expected_qf) { 'field_label_tesim field_label_dtrsim' }

    its(:qf) { is_expected.to eq(expected_qf) }
    its(:pf) { is_expected.to eq(expected_qf) }
    its(:solr_search_params) { is_expected.to eq(qf: expected_qf, pf: expected_qf) }
  end
end
