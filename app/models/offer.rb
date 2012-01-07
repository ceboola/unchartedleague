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
end
