class Team < ActiveRecord::Base
  has_many :users, :through => :team_participations
  has_many :team_participations, :dependent => :destroy
  has_many :offers, :dependent => :destroy
  
  validates :tag, :presence => true, :length => { :maximum => 4 }, :uniqueness => true
  validates :name, :presence => true, :length => { :maximum => 35 }, :uniqueness => true
  validates :description, :length => { :maximum => 250 }  
 
  def full_name
    "#{full_tag} #{name}"
  end
  
  def full_tag
    "[#{tag}]"
  end
  
  def can_be_managed_by?(user)
    for tp in team_participations
      if tp.is_owner?
        return user == tp.user
      end
    end
    return false
  end
  
  def has_member?(user)
    for tp in team_participations
      if tp.user == user
        return true
      end
    end
    return false
  end
  
  def owner
    for tp in team_participations
      if tp.is_owner?
        return tp.user
      end
    end
    return nil
  end
  
  def to_s
    full_name
  end
end
