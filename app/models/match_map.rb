# encoding: utf-8
class MemberUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)     
    team = nil
    for v in value
      if v.changed? or v.new_record?        
        if team.nil?           
          team = v.team
        elsif team != v.team
          record.errors[:base] << "Nie można aktualizować dwóch drużyn jednocześnie!"
        end
      end
    end
    
    unless team.nil?    
      team_value = value.select { |x| x.team == team and not x.user.nil? }      
      s = Set.new (team_value.collect { |x| x.user.id })
      if s.size < team_value.size
        record.errors[attribute] << "nie może dotyczyć wcześniej wpisanego gracza"
      end
    end
  end
end

class TeamSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)    
    team = nil
    for v in value
      if v.changed? or v.new_record?
        if team.nil? 
          team = v.team
        elsif team != v.team
          record.errors[:base] << "Nie można aktualizować dwóch drużyn jednocześnie!"
        end
      end
    end
    
    unless team.nil?
      team_value = value.select { |x| x.team == team and not x.user.nil?}
      max = record.match.competition.send(options[:max])
      min = record.match.competition.send(options[:min])
      if team_value.size < min or team_value.size > max
        record.errors[:base] << "Drużyna w meczu musi liczyć #{min}-#{max} graczy"
      end
    end
  end
end

class MatchMap < ActiveRecord::Base 
  belongs_to :match
  belongs_to :map
  
  has_many :match_entries, :dependent => :destroy, :order => 'score desc, kills desc, deaths asc, assists desc' # FIXME
  has_one :match_map_image, :dependent => :destroy

  accepts_nested_attributes_for :match_entries, :reject_if => :entry_blank?
  
  after_validation :remove_blank_users
  
  validates :match_entries, :member_uniqueness => true, :team_size => { :min => "min_players_per_team", :max => "max_players_per_team" }
 
  def entry_blank? (attributes)
    attributes["score"].blank? and attributes["kills"].blank? and attributes["deaths"].blank? and attributes["assists"].blank?    
  end
   
  def remove_blank_users
    blank = match_entries.select { |x| x.user.nil? }
    blank.each { |x|
      x.destroy
      match_entries.delete x
    }
  end
  
  def winning_team
    score1 = team1score
    score2 = team2score
    if score1 > score2
      match.team1
    elsif score2 > score1
      match.team2
    else
      nil
    end
  end
  
  def team1score
    MatchEntry.where("match_map_id = ? and team_id = ?", id, match.team1.id).sum("kills")
  end
  
  def team2score
    MatchEntry.where("match_map_id = ? and team_id = ?", id, match.team2.id).sum("kills")
  end
  
  def team_in_game(team) # FIXME
    hash = match.team1.id + match.team2.id + id
    if team == match.team2
      hash += 1
    end
    return ["Bohaterowie", "Czarne charaktery"][hash%2]
  end
end
