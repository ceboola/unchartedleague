class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.id == 1
      can :manage, Round
      can :manage, Competition
      can :manage, Match
    end
    can :read, Competition
  end  
end
