# frozen_string_literal: true

module DataDictionary
  class FieldChangeSet < Valkyrie::ChangeSet
    property :label, multiple: false, required: true
    validates :label, presence: true, 'data_dictionary/unique': true

    property :field_type, multiple: false, default: 'string'
    validates :field_type, inclusion: { in: Field::FieldTypes.values }

    property :requirement_designation, multiple: false, default: 'optional'
    validates :requirement_designation, inclusion: { in: Field::RequirementDesignations.values }

    property :validation, multiple: false, default: Validation::Factory.default_key.to_s
    validates :validation, inclusion: { in: Field::FieldValidators.values }

    property :controlled_vocabulary, multiple: false, default: ControlledVocabulary::Factory.default_key.to_s
    validates :controlled_vocabulary, inclusion: { in: Field::FieldVocablaries.values }
    property :default_value, multiple: false
    property :display_name, multiple: false
    property :display_transformation, multiple: false, default: DisplayTransformation::Factory.default_key.to_s

    property :multiple, multiple: false, default: false
    validates :multiple, with: :coerce_into_boolean

    property :help_text, multiple: false, default: ''
    property :index_type, multiple: false, default: 'no_facet'
    validates :index_type, inclusion: { in: Field::IndexTypes.values }

    property :core_field, multiple: false, default: false
    validates :core_field, with: :coerce_into_boolean

    # rubocop:disable Style/NumericPredicate
    # Rubocop wants to use {multiple.zero?} but that breaks things.
    # Need to find a better way to coerce booleans.
    def coerce_into_boolean(field)
      field_value = self[field]
      return if field_value.is_a?(TrueClass) || field_value.is_a?(FalseClass)
      if ['false', '0', 0].include? field_value
        send("#{field}=", false)
      elsif ['true', '1', 1].include? field_value
        send("#{field}=", true)
      else
        errors.add(field, 'is the wrong type')
      end
    end
    # rubocop:enable Style/NumericPredicate
  end
end
