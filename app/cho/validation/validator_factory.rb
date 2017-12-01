# frozen_string_literal: true

module Validation
  class ValidatorFactory
    attr_reader :validator_list

    def initialize(validators = { no_validation: NoneValidator.new })
      @validator_list = validators
      non_validators = @validator_list.reject { |_label, validator| validator.is_a? Validation::Validator }
      if !non_validators.empty?
        error_list = non_validators.map { |label, _err_validator| label }.join(', ')
        raise "Invalid validator(s) in validation list: #{error_list}"
      end
    end

    def lookup(validation_name)
      validator_list[validation_name]
    end

    def validators
      validator_list.keys.map(&:to_s)
    end
  end
end
