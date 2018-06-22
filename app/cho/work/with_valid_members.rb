# frozen_string_literal: true

module Work::WithValidMembers
  # @note modifies the elements in the field to contain resources that exist. Any non-existing
  #   resources are added as errors to the change set.
  def validate_members!(field)
    members = self[field].map { |id| Member.new(id) }
    members.each do |member|
      errors.add(field, "#{member.id} does not exist") unless member.exists?
    end
  end

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
