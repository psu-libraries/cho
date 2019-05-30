# frozen_string_literal: true

require 'spec_helper'
require 'rspec/its'
require_relative '../../../app/cho/indexing/edtf_date_range_formatter'

RSpec.describe Indexing::EdtfDateRangeFormatter do
  describe '.format' do
    { # GIVEN       => EXPECTED
      # Certain dates
      '2019-05-01'  => '2019-05-01',
      '2019-05'     => '2019-05',
      '2019'        => '2019',

      # Certain dates with unspecified parts
      '2019-05-uu'  => '2019-05',
      '2019-uu'     => '2019',
      '2019-uu-uu'  => '2019',

      # Uncertain dates
      '2019-05-29?' => '[2019-05-28 TO 2019-05-30]',
      '2019-05?'    => '[2019-04 TO 2019-06]',
      '2019?'       => '[2018 TO 2020]',

      # Intervals
      '1965/1975'             => '[1965 TO 1975]',
      '2004-06/2006-08'       => '[2004-06 TO 2006-08]',
      '2004-02-01/2005-02-08' => '[2004-02-01 TO 2005-02-08]',

      # Intervals with unspecified parts
      '2019-05-uu/2019-06-uu' => '[2019-05 TO 2019-06]',

      # Intervals with uncertain dates
      '1984/2004-06?' => '[1984 TO 2004-07]', # Note end of exploded uncertainty
      '1984?/2004?'   => '[1983 TO 2005]', # Note bounds of exploded uncertainty

      # Bogus data
      'not a date'    => nil,

      # Can give an EDTF Date object, too!
      Date.edtf('2019') => '2019'

    }.each do |edtf_date, expected_output|
      context "given #{edtf_date.inspect}" do
        subject { described_class.format(edtf_date) }

        it { is_expected.to eq expected_output }
      end
    end
  end
end
