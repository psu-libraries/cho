# frozen_string_literal: true

module Collection::CommonFields
  extend ActiveSupport::Concern

  Workflow = ['default', 'mediated'].freeze
  Visibility = ['public', 'authenticated', 'private'].freeze

  included do
    attribute :id, Valkyrie::Types::ID.optional
    attribute :title, Valkyrie::Types::String
    attribute :subtitle, Valkyrie::Types::String
    attribute :description, Valkyrie::Types::String
    attribute :workflow, Valkyrie::Types::Set.member(Valkyrie::Types::String.enum(*Workflow))
    attribute :visibility, Valkyrie::Types::Set.member(Valkyrie::Types::String.enum(*Visibility))
  end
end
