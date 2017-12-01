# frozen_string_literal: true

# Contains all the fields available in the entire application.
module MetadataApplicationProfile::BaseMAP
  extend ActiveSupport::Concern

  included do
    MetadataApplicationProfile::Field.all.each do |field|
      attribute field.label.parameterize.underscore.to_sym, Valkyrie::Types::Set
    end
  end
end
