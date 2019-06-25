# frozen_string_literal: true

module Validation
  class ValidationsController < ApplicationController
    skip_authorize_resource only: :validate

    before_action do
      head :unprocessable_entity unless validator_class
    end

    def validate
      if validator.validate(params.fetch(:value, nil))
        render json: { valid: true }
      else
        render json: { valid: false, errors: validator.errors }
      end
    end

    private

      def validator
        @validator ||= validator_class.new
      end

      def validator_class
        Validation::Factory.lookup(params.fetch(:validation).to_sym)
      end
  end
end
