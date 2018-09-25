# frozen_string_literal: true

module Schema
  class InputField
    include ActionView::Helpers::OutputSafetyHelper

    attr_reader :form, :metadata_field

    delegate :text?, :required?, :valkyrie_id?, to: :metadata_field

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

    def display_label
      metadata_field.display_name || metadata_field.label.titleize
    end

    def field
      if text?
        form.text_area metadata_field.label, options_for_text_area
      elsif valkyrie_id?
        form.text_field metadata_field.label, options_for_valkyrie_id
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

      def options_for_valkyrie_id
        options_for_required_fields.merge!(list: metadata_field.label)
      end
  end
end
