# frozen_string_literal: true

module Collection::CommonFields
  extend ActiveSupport::Concern
  include DataDictionary::FieldsForObject
  include Repository::AccessControls::Fields

  WORKFLOW = ['default', 'mediated'].freeze

  included do
    attribute :workflow, Valkyrie::Types::Set.of(Valkyrie::Types::String.enum(*WORKFLOW))
  end
end
