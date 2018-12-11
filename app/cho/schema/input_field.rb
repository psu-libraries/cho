# frozen_string_literal: true

module Schema
  class InputField
    include ActionView::Helpers::OutputSafetyHelper

    attr_reader :form, :metadata_field

    delegate :text?, :required?, :valkyrie_id?, :label, to: :metadata_field

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
      if text? || valkyrie_id?
        metadata_field.field_type
      else
        'string'
      end
    end

    def options
      { required: required?, 'aria-required': required? }
    end

    def datalist
      ControlledVocabulary::Factory.lookup(metadata_field.controlled_vocabulary.to_sym).list
    end

    def value
      form.object.send(label).first
    end
  end
end
