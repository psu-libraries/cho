# frozen_string_literal: true

module Agent
  class Resource < Valkyrie::Resource
    include CommonQueries

    attribute :given_name, Valkyrie::Types::String
    attribute :surname, Valkyrie::Types::String
  end
end
