# frozen_string_literal: true

class Work::File < Valkyrie::Resource
  include CommonQueries

  attribute :id, Valkyrie::Types::ID.optional
  attribute :original_filename, Valkyrie::Types::String
  attribute :use, Valkyrie::Types::Set
  attribute :file_identifier, Valkyrie::Types::ID.optional

  # @return [String] path to binary file
  def path
    return unless file_identifier
    file_identifier.id.gsub('disk://', '')
  end
end
