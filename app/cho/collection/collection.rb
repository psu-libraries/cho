# frozen_string_literal: true

class Collection < Valkyrie::Resource
  include CommonQueries

  Types = ['archival', 'library', 'curated'].freeze

  include Valkyrie::Resource::AccessControls
  attribute :id, Valkyrie::Types::ID.optional
  attribute :title, Valkyrie::Types::String
  attribute :description, Valkyrie::Types::String
  attribute :collection_type, Valkyrie::Types::Array.member(Valkyrie::Types::String.enum(*Types))
end
