# frozen_string_literal: true

class Ability
  include CanCan::Ability
  include Blacklight::AccessControls::Ability

  self.ability_logic += %i[
    base_permissions
    authenticated_permissions
    admin_permissions
  ]

  def base_permissions
    can :manage, %i[
      bookmark
      search_history
      devise_remote
      session
    ]
  end

  def authenticated_permissions
    can :read, :all if current_user.login?
  end

  def admin_permissions
    can :manage, :all if current_user&.admin?
  end
end
