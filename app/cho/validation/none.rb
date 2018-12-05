# frozen_string_literal: true

module Validation
  class None < Base
    def validate(_field)
      @errors = []
      true
    end
  end
end
