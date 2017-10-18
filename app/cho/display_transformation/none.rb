# frozen_string_literal: true

module DisplayTransformation
  class None < Base
    def transform(field)
      field
    end
  end
end
