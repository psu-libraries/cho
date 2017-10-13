# frozen_string_literal: true

class WorkObject < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls
  include MetadataApplicationProfile::BaseMAP
  attribute :id, Valkyrie::Types::ID.optional
  attribute :work_type, Valkyrie::Types::String

  def self.all
    Valkyrie.config.metadata_adapter.query_service.find_all_of_model(model: self)
  end
end
