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
      CsvMetadataApplicationProfileField.default_attributes
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

      CsvMetadataApplicationProfileField.new(metadata_field, export_attributes).to_csv
    end
end
