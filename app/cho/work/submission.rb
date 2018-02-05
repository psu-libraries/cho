# frozen_string_literal: true

module Work
  class Submission < Valkyrie::Resource
    include Valkyrie::Resource::AccessControls
    include DataDictionary::FieldsForObject
    include CommonQueries

    attribute :id, Valkyrie::Types::ID.optional
    attribute :work_type, Valkyrie::Types::String
  end
end
