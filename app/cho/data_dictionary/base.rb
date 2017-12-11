# frozen_string_literal: true

# Contains all the fields available in the entire application.
#  Does this by looping through all the fields defined in the system.
module DataDictionary::Base
  extend ActiveSupport::Concern

  included do
    DataDictionary::Field.all.each do |field|
      attribute field.label.parameterize.underscore.to_sym, Valkyrie::Types::Set
    end
  end
end
