class Match < ActiveRecord::Base
  belongs_to :competition
  belongs_to :team1, :class_name => "Team"
  belongs_to :team2, :class_name => "Team"
  belongs_to :judge, :class_name => "User"
  
  def self.filtered(user)
    unless user.nil?      
      ids = user.user_teams_ids
      Match.where('team1_id in (?) or team2_id in (?)', ids, ids)
    else
      Match.scoped
    end
  end
  
  def open_spot?
    team2.nil?
  end
  
  def result
    "-:-"
  end
end
