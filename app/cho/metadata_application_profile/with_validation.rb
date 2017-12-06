# frozen_string_literal: true

module MetadataApplicationProfile::WithValidation
  extend ActiveSupport::Concern

  FieldValidators = Valkyrie::Types::String.enum(*Validation::Factory.validator_names)

  included do
    attribute :validation, FieldValidators
  end
end
