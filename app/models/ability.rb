class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.id == 1 # FIXME
      can :manage, Round
      can :manage, Competition
      can :manage, Match
      can :manage, Award
      can :manage, Comment
      can :manage, Article
      can :manage, Map
      can :manage, Team
      can :manage, User
    else
      can :read, Competition
      can :read, Article
      can [:create, :read], Team      
      can :read, User
      cannot [:read, :manage], Award
    end
  end  
end
