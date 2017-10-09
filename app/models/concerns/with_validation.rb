# frozen_string_literal: true

module WithValidation
  extend ActiveSupport::Concern

  included do
    enum validation: Validation::ValidatorFactory.new.to_string_enum
  end
end
