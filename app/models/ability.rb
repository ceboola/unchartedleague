class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :update, Match, :judge_id => user.id
    can :manage, MatchEntry, :match => { :judge_id => user.id }
  end  
end
