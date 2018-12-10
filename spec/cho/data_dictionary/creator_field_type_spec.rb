# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataDictionary::CreatorFieldType, type: :model do
  subject { described_class.new(subject: 'subject', role: 'role', agent: 'agent') }

  describe '#subject' do
    its(:subject) { is_expected.to eq('subject') }
  end

  describe '#role' do
    its(:role) { is_expected.to eq('role') }
  end

  describe '#agent' do
    its(:agent) { is_expected.to eq('agent') }
  end
end
