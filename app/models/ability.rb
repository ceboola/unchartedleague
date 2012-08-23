class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.id == 1
      can :manage, Round
      can :manage, Competition
      can :manage, Match
      can :manage, Award
    else
      can :read, Competition
      cannot [:read, :manage], Award
    end
  end  
end
