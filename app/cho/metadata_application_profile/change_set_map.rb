# frozen_string_literal: true

# Contains all the fields available in the entire application.
# @todo Only a placeholder module until all the field definitions are added.
module MetadataApplicationProfile::ChangeSetMAP
  extend ActiveSupport::Concern

  included do
    # @todo Example property only; can be removed or renamed
    MetadataApplicationProfile::Field.all.each do |field|
      property field.label.parameterize.underscore.to_sym, multiple: field.multiple?, required: field.required_to_publish?
      validates field.label.parameterize.underscore.to_sym, presence: field.required_to_publish?
    end
  end
end
