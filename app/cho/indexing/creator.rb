# frozen_string_literal: true

module Indexing
  class Creator
    attr_reader :hash_values, :solr_field

    def initialize(values:, solr_field:)
      @hash_values = values.map { |hash| HashCreator.new(hash) }
      @solr_field = solr_field
    end

    def to_solr
      {
        solr_field => hash_values.map(&:display_name).compact,
        'creator_role_tesim' => hash_values.map(&:role).compact,
        'creator_role_ssim' => hash_values.map(&:role).compact,
        'creator_agent_tesim' => hash_values.map(&:agent_display).compact,
        'creator_role_id_ssim' => hash_values.map(&:role_id).compact,
        'creator_agent_id_ssim' => hash_values.map(&:agent_id).compact.map(&:to_s)
      }
    end

    class HashCreator
      attr_reader :role_id, :agent_id

      def initialize(arg)
        @role_id = arg.fetch(:role, nil)
        @agent_id = arg.fetch(:agent)
      end

      # @todo RDF::Vocab might have a more efficient way of searching through terms to retrieve one
      #       based on its uri.
      # @return [String]
      def role
        return if role_id.blank?

        RDF::Vocab::MARCRelators.to_a.select { |relator| relator.to_uri == role_id }.first.label.to_s
      end

      # @return [String]
      def agent
        return if agent_id.blank?

        Agent::Resource.find(Valkyrie::ID.new(agent_id))
      end

      def agent_display
        return if blank?

        agent.to_s
      end

      def blank?
        role.blank? && agent.blank?
      end

      def display_name
        return if blank?

        [agent.display_name, role].compact.join(', ')
      end
    end
  end
end
