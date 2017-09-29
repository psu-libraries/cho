# frozen_string_literal: true

require 'csv'

class CsvMetadataFieldListPresenter
  attr_reader :metadata_application_profile_field_list, :export_attributes

  def initialize(metadata_application_profile_field_list, export_attributes = nil)
    self.export_attributes = export_attributes
    @metadata_application_profile_field_list = metadata_application_profile_field_list
  end

  def to_csv
    csv_header + csv_lines
  end

  private

    def export_attributes=(attributes)
      @export_attributes = if attributes.blank?
                             default_attributes
                           else
                             attributes.map(&:to_s) & MetadataApplicationProfileField.attribute_names
                           end
    end

    def default_attributes
      [:label, :field_type, :requirement_designation,
       :validation, :multiple, :controlled_vocabulary,
       :default_value, :display_name, :display_transformation].map(&:to_s)
    end

    def csv_header
      headers = export_attributes.map(&:titleize)
      ::CSV.generate_line(headers)
    end

    def csv_lines
      metadata_application_profile_field_list.map do |metadata_field|
        csv_line(metadata_field)
      end.join('')
    end

    def csv_line(metadata_field)
      return '' if metadata_field.blank?

      values = metadata_field.attributes.slice(*export_attributes).values
      ::CSV.generate_line(values)
    end
end
