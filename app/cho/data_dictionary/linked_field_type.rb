# frozen_string_literal: true

module DataDictionary
  class LinkedFieldType
    attr_reader :subject, :object, :predicate

    def initialize(subject:, object:, predicate:)
      @subject = subject
      @object = object
      @predicate = predicate
    end
  end
end
