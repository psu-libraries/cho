# frozen_string_literal: true

module Collection
  class CuratedChangeSet < Valkyrie::ChangeSet
    include ChangeSetBehaviors
  end
end
