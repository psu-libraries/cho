# frozen_string_literal: true

module MetadataApplicationProfile::WithDisplayTransformation
  extend ActiveSupport::Concern

  FieldDisplayTransformations = Valkyrie::Types::String.enum(*DisplayTransformation::Factory.transformation_names)

  included do
    attribute :display_transformation, FieldDisplayTransformations
  end
end
