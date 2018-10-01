# frozen_string_literal: true

# Null schema so resources may have a schema present, but without any fields
module Schema
  class None
    def fields
      []
    end

    def core_fields
      []
    end
  end
end
