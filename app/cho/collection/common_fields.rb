# frozen_string_literal: true

module Collection::CommonFields
  extend ActiveSupport::Concern

  WORKFLOW = ['default', 'mediated'].freeze
  VISIBILITY = ['public', 'authenticated', 'private'].freeze

  included do
    attribute :id, Valkyrie::Types::ID.optional
    attribute :title, Valkyrie::Types::String
    attribute :subtitle, Valkyrie::Types::String
    attribute :description, Valkyrie::Types::String
    attribute :workflow, Valkyrie::Types::Set.member(Valkyrie::Types::String.enum(*WORKFLOW))
    attribute :visibility, Valkyrie::Types::Set.member(Valkyrie::Types::String.enum(*VISIBILITY))
  end
end
