# frozen_string_literal: true

module DisplayTransformation
  class Factory
    def self.transformations=(new_transformations)
      non_transformations = new_transformations.reject { |_label, transformation| transformation.is_a? DisplayTransformation::Base }
      if non_transformations.present?
        error_list = non_transformations.keys.join(', ')
        raise Error.new("Invalid display transformations(s) in transformation list: #{error_list}")
      end

      @transformations = new_transformations.merge(none: DisplayTransformation::None.new)
    end

    def self.transformations
      @transformations ||= { none: DisplayTransformation::None.new }
    end

    def self.lookup(transformation_name)
      transformations[transformation_name]
    end
  end
end
