# frozen_string_literal: true

# Loops through the DataDictionary Fields and applies the changeset properties to the
#  class this is included in
module DataDictionary::ChangeSet
  extend ActiveSupport::Concern

  included do
    DataDictionary::Field.all.each do |field|
      property field.label.parameterize.underscore.to_sym, multiple: field.multiple?, required: field.required_to_publish?
      validates field.label.parameterize.underscore.to_sym, presence: field.required_to_publish?
    end
  end
end
