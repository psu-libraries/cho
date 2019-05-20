# frozen_string_literal: true

module Transaction
  class Rejection
    include ActiveModel::Validations

    attr_reader :message

    def initialize(tag, error)
      ErrorReportingService.call(error) if should_notify_error?
      raise error if should_raise_error?

      @message = "#{tag}: #{error.message}"
      errors.add(:transaction, message)
    end

    def to_s
      message
    end

    private

      def should_raise_error?
        Rails.env.development?
      end

      def should_notify_error?
        !(Rails.env.development? || Rails.env.test?)
      end
  end
end
