# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validation::ValidationsController, type: :routing do
  describe 'routing' do
    it 'routes to #validate' do
      expect(post: '/validations/my_validation').to route_to(
        controller: 'validation/validations',
        action: 'validate',
        validation: 'my_validation'
      )
    end
  end
end
