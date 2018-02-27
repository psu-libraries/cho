# frozen_string_literal: true

module Collection
  class Archival < Valkyrie::Resource
    include Valkyrie::Resource::AccessControls
    include CommonFields
    include CommonQueries
    include WithMembers

    def self.model_name
      ActiveModel::Name.new(self, nil, 'archival_collection')
    end
  end
end
