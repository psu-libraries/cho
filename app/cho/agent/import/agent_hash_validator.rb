# frozen_string_literal: true

module Agent
  module Import
    class AgentHashValidator < Work::Import::WorkHashValidator
      alias :agent_hash :work_hash

      private

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

        def clean_hash
          # noop
        end
    end
  end
end
