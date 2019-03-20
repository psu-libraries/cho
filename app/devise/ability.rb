# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    can :manage, %i[bookmark catalog download search_history]

    can :manage, :all if user&.admin?
  end
end
