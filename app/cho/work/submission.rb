# frozen_string_literal: true

module Work
  class Submission < Valkyrie::Resource
    include Valkyrie::Resource::AccessControls
    include DataDictionary::FieldsForObject
    include CommonQueries

    attribute :id, Valkyrie::Types::ID.optional
    attribute :work_type, Valkyrie::Types::String

    # A list of Work::Files.
    #  The stored valkyrie resource for files attached to a submission
    attribute :files, Valkyrie::Types::Set

    # Accessors needed for shrine to send the temporary uploaded file
    #  to the controller
    # For the moment we are uploading a single file.
    attr_accessor :file_data, :cached_file_data, :file
  end
end
