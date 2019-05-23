# frozen_string_literal: true

class Ability
  include CanCan::Ability
  include Blacklight::AccessControls::Ability

  delegate :admin?, to: :current_user

  self.ability_logic += %i[
    base_permissions
    admin_permissions
    cannot_delete_agent_with_members
  ]

  def base_permissions
    can :manage, %i[
      bookmark
      search_history
      devise_remote
      session
    ]
  end

  def admin_permissions
    can :manage, :all if current_user&.admin?
  end

  def cannot_delete_agent_with_members
    cannot :delete, Agent::Resource do |agent|
      agent.member_ids.any?
    end
  end
end
