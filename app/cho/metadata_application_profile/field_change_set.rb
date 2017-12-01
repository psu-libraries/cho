# frozen_string_literal: true

module MetadataApplicationProfile
  class FieldChangeSet < Valkyrie::ChangeSet
    property :label, multiple: false, required: true
    validates :label, presence: true

    property :field_type, multiple: false, default: 'string'
    validates :field_type, inclusion: { in: Field::FieldTypes.values }

    property :requirement_designation, multiple: false, default: 'optional'
    validates :requirement_designation, inclusion: { in: Field::RequirementDesignations.values }

    property :validation, multiple: false, default: 'no_validation'
    validates :validation, inclusion: { in: Field::FieldValidators.values }

    property :controlled_vocabulary, multiple: false
    property :default_value, multiple: false
    property :display_name, multiple: false
    property :display_transformation, multiple: false

    property :multiple, multiple: false, default: false
    validates :multiple, with: :coerce_into_boolean

    # rubocop:disable Style/NumericPredicate
    # Rubocop wants to use {multiple.zero?} but that breaks things.
    # Need to find a better way to coerce booleans.
    def coerce_into_boolean(_field)
      return if multiple.is_a?(TrueClass) || multiple.is_a?(FalseClass)
      if multiple == 'false' || multiple == '0' || multiple == 0
        self.multiple = false
      elsif multiple == 'true' || multiple == '1' || multiple == 1
        self.multiple = true
      else
        errors.add(:multiple, 'is the wrong type')
      end
    end
    # rubocop:enable Style/NumericPredicate
  end
end
