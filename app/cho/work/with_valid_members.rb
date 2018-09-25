# frozen_string_literal: true

module Work::WithValidMembers
  # @note modifies the elements in the field to contain resources that exist. Any non-existing
  #   resources are added as errors to the change set.
  def validate_members!(field)
    members = self[field].map { |id| Validation::Member.new(id) }
    members.each do |member|
      errors.add(field, "#{member.id} does not exist") unless member.exists?
    end
  end
end
