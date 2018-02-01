# frozen_string_literal: true

module Collection
  class Library < Valkyrie::Resource
    include Valkyrie::Resource::AccessControls
    include CommonFields
    include CommonQueries

    def self.model_name
      ActiveModel::Name.new(self, nil, 'library_collection')
    end
  end
end
