# frozen_string_literal: true

class Work::File < Valkyrie::Resource
  include CommonQueries

  attribute :id, Valkyrie::Types::ID.optional
  attribute :original_filename, Valkyrie::Types::String
  attribute :use, Valkyrie::Types::Set
  attribute :file_identifier, Valkyrie::Types::ID.optional
end
