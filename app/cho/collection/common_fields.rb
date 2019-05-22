# frozen_string_literal: true

module Collection::CommonFields
  extend ActiveSupport::Concern
  include DataDictionary::FieldsForObject

  WORKFLOW = ['default', 'mediated'].freeze

  included do
    attribute :workflow, Valkyrie::Types::Set.of(Valkyrie::Types::String.enum(*WORKFLOW))
    attribute :access_level, Valkyrie::Types::Set.of(Valkyrie::Types::String.enum(*Repository::AccessLevel.names))
  end
end
