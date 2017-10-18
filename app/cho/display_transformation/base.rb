# frozen_string_literal: true

module DisplayTransformation
  class Base
    def transform(_field)
      raise Error.new('DisplayTransformation.transform is abstract. Children must implement.')
    end
  end
end
