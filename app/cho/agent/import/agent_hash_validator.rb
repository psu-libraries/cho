# frozen_string_literal: true

module Agent
  module Import
    class AgentHashValidator
      attr_reader :change_set, :agent_hash

      def initialize(agent_hash)
        @agent_hash = agent_hash
        @change_set = build_change_set
        @change_set.validate(agent_hash)
      end

      private

        def updating?
          agent_hash.key?('id')
        end

        def build_change_set
          if submission.nil?
            MissingChangeSet.new(MissingResource.new)
          else
            ChangeSet.new(submission)
          end
        end

        def submission
          @submission ||= if updating?
                            Resource.find(Valkyrie::ID.new(agent_hash['id']))
                          else
                            Resource.new
                          end
        end

        class MissingResource < Valkyrie::Resource
        end

        class MissingChangeSet < Valkyrie::ChangeSet
          def errors
            current_errors = super
            current_errors.add(:id, 'does not exist') unless current_errors.key?(:id)
            current_errors
          end

          def valid?
            false
          end
        end
    end
  end
end
