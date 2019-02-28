# frozen_string_literal: true

module Validation
  class Member
    attr_reader :id

    def initialize(id)
      @id = Valkyrie::ID.new(id)
    end

    def exists?
      Valkyrie.config.metadata_adapter.query_service.find_by(id: id)
      true
    rescue Valkyrie::Persistence::ObjectNotFoundError
      false
    end
  end
end
