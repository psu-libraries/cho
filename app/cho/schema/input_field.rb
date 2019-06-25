# frozen_string_literal: true

module Schema
  class InputField
    include ActionView::Helpers::OutputSafetyHelper

    attr_reader :form, :metadata_field

    delegate :text?, :required?, :valkyrie_id?, :linked_field?, :creator?, :radio_button?, :label,
             :validation, :controlled_vocabulary, to: :metadata_field
    delegate :url_helpers, to: 'Rails.application.routes'

    # @param [ActionView::Helpers::FormBuilder] form
    # @param [Schema::MetadataField] metadata_field
    def initialize(form:, metadata_field:)
      @form = form
      @metadata_field = metadata_field
    end

    def display_label
      metadata_field.display_name || metadata_field.label.titleize
    end

    def partial
      if text? || valkyrie_id? || creator? || radio_button?
        metadata_field.field_type
      else
        'string'
      end
    end

    def values
      return empty_values if value_set.empty?

      value_set
    end

    def multiple?
      metadata_field.multiple
    end

    def options
      {
        required: required?,
        'aria-required': required?,
        class: 'form-control'
      }.merge(validation_options)
    end

    def data_attributes
      return {} unless multiple?

      { controller: 'fields' }
    end

    def datalist(component: nil)
      ControlledVocabulary::Factory.lookup(metadata_field.controlled_vocabulary.to_sym).list(component: component)
    end

    def value
      value_set.first
    end

    private

      def value_set
        @value_set ||= Array.wrap(form.object.send(label.to_sym))
      end

      def empty_values
        return [{}] if linked_field?

        ['']
      end

      # @note don't perform remote validations on properties that have a controlled vocabulary.
      def validation_options
        return {} if validation == 'no_validation' || controlled_vocabulary != 'no_vocabulary'

        {
          data: {
            action: 'fields#validate', url: url_helpers.validations_path(validation: metadata_field.validation)
          }
        }
      end
  end
end
