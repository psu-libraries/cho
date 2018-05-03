# frozen_string_literal: true

module Schema
  class InputField
    include ActionView::Helpers::OutputSafetyHelper

    attr_reader :form, :metadata_field

    delegate :text?, :required?, to: :metadata_field

    # @param [ActionView::Helpers::FormBuilder] form
    # @param [Schema::MetadataField] metadata_field
    def initialize(form:, metadata_field:)
      @form = form
      @metadata_field = metadata_field
    end

    def label
      form.label metadata_field.label, metadata_field.display_name do
        yield if block_given?
      end
    end

    def label_text
      metadata_field.label
    end

    def field
      if text?
        form.text_area metadata_field.label, options_for_text_area
      else
        form.text_field metadata_field.label, options_for_required_fields
      end
    end

    private

      def options_for_required_fields
        return {} unless required?
        { required: true, 'aria-required' => true }
      end

      def options_for_text_area
        options_for_required_fields.merge!(value: form.object.send(metadata_field.label).first)
      end
  end
end
