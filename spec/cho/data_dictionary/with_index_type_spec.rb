# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::WithIndexType, type: :model do
  before (:all) do
    class MyFieldModel < Valkyrie::Resource
      include DataDictionary::WithIndexType
    end
  end

  after (:all) do
    ActiveSupport::Dependencies.remove_constant('MyFieldModel')
  end

  subject { model }

  let(:model) { MyFieldModel.new }

  context 'when there is no index type' do
    it { is_expected.not_to be_facet }
    it { is_expected.not_to be_no_facet }
    it { is_expected.not_to be_date }
  end

  context 'when the index type is a facet' do
    before { model.facet! }

    it { is_expected.to be_facet }
    it { is_expected.not_to be_no_facet }
    it { is_expected.not_to be_date }
  end

  context 'when the index type is no facet' do
    before { model.no_facet! }

    it { is_expected.not_to be_facet }
    it { is_expected.to be_no_facet }
    it { is_expected.not_to be_date }
  end

  context 'when the index type is a date' do
    before { model.date! }

    it { is_expected.not_to be_facet }
    it { is_expected.not_to be_no_facet }
    it { is_expected.to be_date }
  end

  context 'index_type is bogus' do
    it 'raises an error' do
      expect { MyFieldModel.new(index_type: 'bogus') }.to raise_error(Dry::Struct::Error)
    end
  end
end
