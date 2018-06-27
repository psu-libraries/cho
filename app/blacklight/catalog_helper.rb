# frozen_string_literal: true

module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  ##
  # Look up the label for the index field
  def index_field_label(document, field)
    lookup_display_name(document, field) || super
  end

  ##
  # Look up the label for the show field
  def document_show_field_label(document, field)
    lookup_display_name(document, field) || super
  end

  private

    def lookup_display_name(document, field)
      return nil if document.schema.blank?

      parts = field.split('_')
      field_label = parts[0, parts.count - 1].join('_')
      field_schema = document.schema.field(field_label)

      return nil if field_schema.blank?

      field_schema.display_name
    end
end
