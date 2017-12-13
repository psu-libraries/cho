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

  subject { model.index_type }

  let(:index_type) { 'facet' }
  let(:model) { MyFieldModel.new(index_type: index_type) }

  it { is_expected.to eq('facet') }

  it 'is facet' do
    expect(model).to be_facet
  end

  it 'is not no_facet' do
    expect(model).not_to be_no_facet
  end

  context 'index_type is set to none' do
    before do
      model.no_facet!
    end

    it 'is no facet' do
      expect(model).to be_no_facet
    end

    it 'is not facet' do
      expect(model).not_to be_facet
    end

    context 'and then set to facet' do
      before do
        model.facet!
      end

      it 'is not no facet' do
        expect(model).not_to be_no_facet
      end

      it 'is facet' do
        expect(model).to be_facet
      end
    end
  end

  context 'index_type is bogus' do
    let(:index_type) { 'bogus' }

    it 'raises an error' do
      expect { model }.to raise_error(Dry::Struct::Error)
    end
  end
end
