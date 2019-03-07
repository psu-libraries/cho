# frozen_string_literal: true

module Validation
  class Creator < Base
    def validate(field_value)
      self.errors = []
      Array.wrap(field_value).each do |value|
        self.errors += CreatorHashValidator.new(value).errors
      end
      self.errors.empty?
    end

    class CreatorHashValidator
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def errors
        creator_hash.assert_valid_keys('role', 'agent')
        error_messages
      rescue ArgumentError
        [I18n.t('cho.validation.creator.hash_keys')]
      end

      private

        def creator_hash
          @creator_hash ||= ActiveSupport::HashWithIndifferentAccess.new(value).stringify_keys
        end

        def error_messages
          messages = []
          messages << I18n.t('cho.validation.creator.role', role: role) unless valid_role?
          messages << I18n.t('cho.validation.creator.agent', agent: agent) unless valid_agent?
          messages
        end

        def role
          creator_hash['role']
        end

        def agent
          creator_hash['agent']
        end

        def valid_agent?
          return true if agent.blank?
          Validation::Member.new(agent).exists?
        end

        def valid_role?
          return true if role.blank?
          RDF::Vocab::MARCRelators.to_a.map(&:to_s).include?(role)
        end
    end
  end
end
