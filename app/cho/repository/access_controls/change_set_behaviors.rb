# frozen_string_literal: true

module Repository::AccessControls::ChangeSetBehaviors
  extend ActiveSupport::Concern

  included do
    property :system_creator, multiple: false, required: true
    validates :system_creator, presence: true

    property :current_user, multiple: false, required: false, virtual: true

    property :discover_groups, multiple: true, required: false
    property :discover_users, multiple: true, required: false
    property :read_groups, multiple: true, required: false
    property :read_users, multiple: true, required: false
    property :download_groups, multiple: true, required: false
    property :download_users, multiple: true, required: false
    property :edit_users, multiple: true, required: false
    property :edit_groups, multiple: true, required: false
  end
end
