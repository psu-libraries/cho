# frozen_string_literal: true

require 'rails_helper'

describe Validation::Methods do
  describe '#edtf_date' do
    before do
      class EdtfDateTest < Valkyrie::Resource
        attribute :date
      end

      class EdtfDateTestChangeSet < Valkyrie::ChangeSet
        include Validation::Methods

        property :date, multiple: true
        validates :date, with: :edtf_date
      end
    end

    after do
      ActiveSupport::Dependencies.remove_constant('EdtfDateTest')
      ActiveSupport::Dependencies.remove_constant('EdtfDateTestChangeSet')
    end

    subject(:change_set) { EdtfDateTestChangeSet.new(EdtfDateTest.new) }

    context 'with a single valid EDTF date' do
      before { change_set.validate(date: '1999-uu-uu') }

      it { is_expected.to be_valid }
    end

    context 'with multiple valid EDTF dates' do
      before { change_set.validate(date: ['1999-uu-uu', '2001-02-uu']) }

      it { is_expected.to be_valid }
    end

    context 'with a single invalid EDTF date' do
      before { change_set.validate(date: 'asdf') }

      it { is_expected.not_to be_valid }
      its(:errors) { is_expected.to include(date: ['asdf is not a valid EDTF date']) }
    end

    context 'with a multiple invalid EDTF dates' do
      before { change_set.validate(date: ['asdf', '2']) }

      it { is_expected.not_to be_valid }
      its(:errors) { is_expected.to include(date: ['asdf is not a valid EDTF date', '2 is not a valid EDTF date']) }
    end

    context 'with both valid and invalid dates' do
      before { change_set.validate(date: ['1984?-01~', 'btw']) }

      it { is_expected.not_to be_valid }
      its(:errors) { is_expected.to include(date: ['btw is not a valid EDTF date']) }
    end

    context 'with a nil date' do
      before { change_set.validate(date: nil) }

      it { is_expected.to be_valid }
    end

    context 'with an empty set of dates' do
      before { change_set.validate(date: []) }

      it { is_expected.to be_valid }
    end
  end
end
