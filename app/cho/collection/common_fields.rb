# frozen_string_literal: true

module Collection::CommonFields
  extend ActiveSupport::Concern
  include DataDictionary::FieldsForObject

  WORKFLOW = ['default', 'mediated'].freeze
  VISIBILITY = ['public', 'authenticated', 'private'].freeze

  included do
    attribute :workflow, Valkyrie::Types::Set.of(Valkyrie::Types::String.enum(*WORKFLOW))
    attribute :visibility, Valkyrie::Types::Set.of(Valkyrie::Types::String.enum(*VISIBILITY))
  end
end
