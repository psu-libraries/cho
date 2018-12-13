# frozen_string_literal: true

module ControlledVocabulary
  class Creators < Base
    class UnsupportedComponentError < StandardError; end

    def self.list(component:)
      case component
      when :agents
        then Agents.list
      when :roles
        then roles
      else
        raise UnsupportedComponentError.new(
          "#{component} is not a supported component of #{self}. Only :agents and :roles are allowed."
        )
      end
    end

    def self.roles
      @roles ||= RDF::Vocab::MARCRelators.to_a
    end
  end
end
