# frozen_string_literal: true

class ErrorReportingService
  def self.call(error)
    return unless defined? NewRelic

    NewRelic::Agent.notice_error(error)
  end
end
