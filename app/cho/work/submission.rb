# frozen_string_literal: true

module Work
  class Submission < Valkyrie::Resource
    include Valkyrie::Resource::AccessControls
    include DataDictionary::FieldsForObject
    include CommonQueries

    attribute :id, Valkyrie::Types::ID.optional
    attribute :work_type_id, Valkyrie::Types::ID.optional

    # TODO  The default canbe removed after we upgrade to Valkyrie 1.0
    attribute :member_of_collection_ids, Valkyrie::Types::Set.of(Valkyrie::Types::ID).default([])

    # A list of Work::Files.
    #  The stored valkyrie resource for files attached to a submission
    attribute :files, Valkyrie::Types::Set

    # Accessors needed for shrine to send the temporary uploaded file
    #  to the controller
    # For the moment we are uploading a single file.
    attr_accessor :file_data, :cached_file_data, :file

    def self.model_name
      Name.new(self)
    end

    # @note Use a custom Name class just to override i18n_key
    class Name < ActiveModel::Name
      def i18n_key
        'work'
      end
    end

    def attributes
      super
    end
  end
end
