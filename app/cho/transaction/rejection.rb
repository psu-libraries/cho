# frozen_string_literal: true

module Transaction
  class Rejection
    include ActiveModel::Validations

    attr_reader :message

    def initialize(message)
      @message = message
      errors.add(:transaction, message)
    end

    def to_s
      message
    end
  end
end
