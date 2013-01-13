class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.id == 1
      can :manage, Round
      can :manage, Competition
      can :manage, Match
      can :manage, Award
      can :manage, Comment
      can :manage, Article
      can :manage, Map
    else
      can :read, Competition
      can :read, Article
      cannot [:read, :manage], Award
    end
  end  
end
