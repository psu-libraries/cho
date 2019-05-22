# frozen_string_literal: true

module Repository::Access::ResourceControls
  extend ActiveSupport::Concern

  included do
    # These are attributes defined in Blacklight's access controls, which are based off of Hydra's
    attribute :discover_groups, Valkyrie::Types::Set
    attribute :discover_users, Valkyrie::Types::Set
    attribute :read_groups, Valkyrie::Types::Set.default([Repository::AccessLevel.public])
    attribute :read_users, Valkyrie::Types::Set
    attribute :download_groups, Valkyrie::Types::Set
    attribute :download_users, Valkyrie::Types::Set

    # Edit attributes found in Hydra, but not in Blacklight
    attribute :edit_users, Valkyrie::Types::Set
    attribute :edit_groups, Valkyrie::Types::Set
  end
end
