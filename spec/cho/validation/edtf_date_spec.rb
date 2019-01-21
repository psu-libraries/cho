# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::EDTFDate, type: :model do
  describe '#validate' do
    subject { validation_instance.validate(dates) }

    let(:validation_instance) { described_class.new }

    context 'with a single valid EDTF date' do
      let(:dates) { '1999-uu-uu' }

      it 'is valid' do
        expect(validation_instance.validate(dates)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with multiple valid EDTF dates' do
      let(:dates) { ['1999-uu-uu', '2001-02-uu'] }

      it 'is valid' do
        expect(validation_instance.validate(dates)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end

    context 'with a single invalid EDTF date' do
      let(:dates) { 'asdf' }

      it 'is invalid' do
        expect(validation_instance.validate(dates)).to be_falsey
        expect(validation_instance.errors).to contain_exactly('Date asdf is not a valid EDTF date')
      end
    end

    context 'with a multiple invalid EDTF dates' do
      let(:dates) { ['asdf', '2'] }

      it 'is invalid' do
        expect(validation_instance.validate(dates)).to be_falsey
        expect(validation_instance.errors).to contain_exactly(
          'Date asdf is not a valid EDTF date',
          'Date 2 is not a valid EDTF date'
        )
      end
    end

    context 'with both valid and invalid dates' do
      let(:dates) { ['1984?-01~', 'btw'] }

      it 'is invalid' do
        expect(validation_instance.validate(dates)).to be_falsey
        expect(validation_instance.errors).to contain_exactly('Date btw is not a valid EDTF date')
      end
    end

    context 'with a nil date' do
      let(:dates) { nil }

      it { is_expected.to be_truthy }
    end

    context 'with an empty set of dates' do
      let(:dates) { [] }

      it { is_expected.to be_truthy }
    end

    context 'with a valid Ruby date' do
      let(:dates) { 'January 21, 2019' }

      it 'is valid' do
        expect(validation_instance.validate(dates)).to be_truthy
        expect(validation_instance.errors).to be_empty
      end
    end
  end
end
