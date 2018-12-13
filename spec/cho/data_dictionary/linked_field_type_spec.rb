# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::LinkedFieldType, type: :model do
  subject { described_class.new(subject: 'subject', predicate: 'predicate', object: 'object') }

  describe '#subject' do
    its(:subject) { is_expected.to eq('subject') }
  end

  describe '#predicate' do
    its(:predicate) { is_expected.to eq('predicate') }
  end

  describe '#object' do
    its(:object) { is_expected.to eq('object') }
  end
end
