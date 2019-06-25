# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::ValidationsController, type: :controller do
  describe 'POST #validate' do
    let(:json) { JSON.parse(response.body) }

    context 'with valid input' do
      before { post :validate, params: { validation: :edtf_date, value: '2016-09-uu' } }

      specify do
        expect(response).to be_success
        expect(json.fetch('valid')).to be_truthy
      end
    end

    context 'with invalid input' do
      before { post :validate, params: { validation: :edtf_date, value: 'BAD DATES' } }

      specify do
        expect(response).to be_success
        expect(json.fetch('valid')).to be_falsey
        expect(json.fetch('errors')).to contain_exactly('Date BAD DATES is not a valid EDTF date')
      end
    end

    context 'with empty input' do
      before { post :validate, params: { validation: :edtf_date, value: '' } }

      specify { expect(response).to be_success }
    end

    context 'with no input' do
      before { post :validate, params: { validation: :edtf_date } }

      specify { expect(response).to be_success }
    end

    context 'with a non-existent validator' do
      before { post :validate, params: { validation: :bogus_validator, value: 'content' } }

      specify { expect(response.status).to eq(422) }
    end
  end
end
