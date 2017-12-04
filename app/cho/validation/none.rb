# frozen_string_literal: true

module Validation
  class None < Base
    def validate(_field)
      true
    end
  end
end
