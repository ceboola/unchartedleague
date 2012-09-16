# encoding: utf-8

class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  validates :content, :presence => true, :length => { :maximum => 350 }
   
  def from
    if originated_from_player
      user
    else
      team
    end
  end
  
  def to
    if originated_from_player
      team
    else
      user
    end
  end
  
  def receiver_email
    if originated_from_player
      team.owner.email
    else
      user.email
    end
  end
  
  def subject
    if originated_from_player
      "Prośba o dołączenie do #{team.name}"
    else
      "Zaproszenie do #{team.name}"
    end
  end
  
  def can_be_processed_by? user
    user == to or (originated_from_player and team.owner == user)
  end
  
  def can_only_be_removed_by? user
    user == from or (not originated_from_player and team.owner == user)
  end
  
  def is_sane?
    begin
      not team.has_member? user and open and not accepted
    rescue Exception
      false
    end
  end
  
  def reject
    begin
      self.accepted = false
      self.open = false
      if save!
        return true
      end      
    rescue Exception      
    end   
    
    return false
  end
  
  def close
    begin
      self.open = false
      if save!
        return true
      end      
    rescue Exception      
    end   
    
    return false
  end
  
  def accept
    begin
      tp = team.team_participations.build
      tp.user = user
      tp.role = TeamParticipation::ROLES.index('first_team')
      tp.active = true
      if tp.save
        self.accepted = true
        self.open = false
        if save
          return true
        end
      end
    rescue Exception      
    end   
    
    return false
  end
  
  def self.received_offers_count(user) # FIXME
    Offer.count(:id, :conditions => ['(team_id in (?) and open = ? and originated_from_player = ?) or (user_id in (?) and open = ? and originated_from_player = ?)', Team.owned_by_user(user).collect {|x| x.id}, true, true, user.id, true, false])
  end
  
  def self.sent_offers_count(user) # FIXME
    Offer.count(:id, :conditions => ['(user_id in (?) and open = ? and originated_from_player = ?) or (team_id in (?) and open = ? and originated_from_player = ?)', user.id, true, true, Team.owned_by_user(user).collect {|x| x.id}, true, false])
  end
  
  def self.sent_offers(user) # FIXME
    where('(user_id in (?) and open = ? and originated_from_player = ?) or (team_id in (?) and open = ? and originated_from_player = ?)', user.id, true, true, Team.owned_by_user(user).collect {|x| x.id}, true, false)
  end
  
  def self.received_offers(user) # FIXME
    where('(team_id in (?) and open = ? and originated_from_player = ?) or (user_id in (?) and open = ? and originated_from_player = ?)', Team.owned_by_user(user).collect {|x| x.id}, true, true, user.id, true, false)
  end
  
  def self.can_create_offers? (user)
    sent_offers_count(user) < 10
  end
end
