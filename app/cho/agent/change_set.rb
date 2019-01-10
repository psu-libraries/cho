# frozen_string_literal: true

module Agent
  class ChangeSet < Valkyrie::ChangeSet
    property :given_name, multiple: false, required: true
    validates :given_name, presence: true

    property :surname, multiple: false, required: true
    validates :surname, presence: true

    validates :given_name, :surname, with: :unique_name

    def to_s
      "#{given_name} #{surname}"
    end

    def unique_name(_attribute)
      return if resource.to_s == to_s
      Agent::Resource.all.map do |agent|
        unique_agent_error(agent)
      end
    end

    private

      def unique_agent_error(agent)
        message = "#{agent} already exists"
        return if errors[:base].include?(message)
        errors.add(:base, message) if agent.to_s == to_s
      end
  end
end
