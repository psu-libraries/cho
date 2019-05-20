# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorReportingService do
  before do
    # New relic gem is currently only required in production
    unless defined? NewRelic
      module NewRelic
        module Agent
          def self.notice_error(*args); end
        end
      end
    end

    allow(NewRelic::Agent).to receive(:notice_error)
  end

  describe '.call' do
    let(:err) { StandardError.new }

    it 'delegates to NewRelic::Agent.notice_error' do
      expect(NewRelic::Agent).to receive(:notice_error).with(err)
      described_class.call(err)
    end
  end
end
