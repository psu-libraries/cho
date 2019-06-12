# frozen_string_literal: true

require 'spec_helper'
require 'active_support'
require_relative '../../../cho/app/valkyrie/date_time_json_value'

RSpec.describe DateTimeJSONValue do
  subject { MyValueMapper.handles?(value) }

  before(:all) do
    class MyValueMapper
    end

    MyValueMapper.singleton_class.send(:prepend, described_class)
  end

  after(:all) do
    ActiveSupport::Dependencies.remove_constant('MyValueMapper')
  end

  context 'when a string has a date with a valid timestamp' do
    let(:value) { '2019-06-11T23:11:13-04:00' }

    it { is_expected.to be_truthy }
  end

  context 'with a string representation of a DateTime' do
    let(:value) { DateTime.now.to_s }

    it { is_expected.to be_truthy }
  end

  context 'when a string has a date without a valid timestamp' do
    let(:value) { '2019-06-11 23:11:13 UTC' }

    it { is_expected.to be_falsey }
  end

  context 'when a string has only a full date' do
    let(:value) { '2112-12-21' }

    it { is_expected.to be_falsey }
  end

  context 'when a string has a year and month' do
    let(:value) { '1999-12' }

    it { is_expected.to be_falsey }
  end

  context 'when a string has only a year' do
    let(:value) { '1999' }

    it { is_expected.to be_falsey }
  end

  context 'with something other than a string' do
    let(:value) { 2 }

    it { is_expected.to be_falsey }
  end
end
