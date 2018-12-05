# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShowPresenter do
  let(:presenter) { described_class.new(document, request_context, config) }
  let(:document) { {} }
  let(:request_context) { double }
  let(:config) { Blacklight::Configuration.new }

  describe '#thumbnail' do
    subject { presenter.thumbnail }

    it { is_expected.to be_instance_of ThumbnailPresenter }
  end
end
