# frozen_string_literal: true

# Contains all the fields available in the entire application.
# @todo Only a placeholder module until all the field definitions are added.
module BaseMAP
  extend ActiveSupport::Concern

  included do
    # @todo Example property only; can be removed or renamed
    attribute :title, Valkyrie::Types::Set
  end
end
