# frozen_string_literal: true

module MetadataApplicationProfile::WithValidation
  extend ActiveSupport::Concern

  FieldValidators = Valkyrie::Types::String.enum(*Validation::ValidatorFactory.new.validators)

  included do
    attribute :validation, FieldValidators
  end
end
