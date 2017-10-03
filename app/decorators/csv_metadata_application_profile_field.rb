# frozen_string_literal: true

require 'csv'

class CsvMetadataApplicationProfileField < Draper::Decorator
  delegate_all

  attr_reader :attributes

  def initialize(metadata_application_profile_field, attributes = self.class.default_attributes)
    super(metadata_application_profile_field)
    @attributes = attributes
  end

  def to_csv
    values = model.attributes.slice(*attributes).values
    ::CSV.generate_line(values)
  end

  def parse(csv_string)
    ::CSV.parse(csv_string) do |row|
      new_attributes = Hash[attributes.zip(row)]
      model.assign_attributes(new_attributes)
    end
    model
  end

  def self.default_attributes
    [:label, :field_type, :requirement_designation,
     :validation, :multiple, :controlled_vocabulary,
     :default_value, :display_name, :display_transformation].map(&:to_s)
  end
end
