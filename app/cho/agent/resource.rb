# frozen_string_literal: true

module Agent
  class Resource < Valkyrie::Resource
    NAME_SEPARATOR = ','

    include CommonQueries

    attribute :given_name, Valkyrie::Types::String
    attribute :surname, Valkyrie::Types::String

    def to_s
      "#{given_name} #{surname}"
    end

    def display_name
      "#{surname}#{NAME_SEPARATOR} #{given_name}"
    end
  end
end
