# frozen_string_literal: true

module Collection
  class Curated < Valkyrie::Resource
    include Valkyrie::Resource::AccessControls
    include CommonFields
    include CommonQueries

    def self.model_name
      ActiveModel::Name.new(self, nil, 'curated_collection')
    end
  end
end
