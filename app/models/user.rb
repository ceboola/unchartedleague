class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :psn_name
  
  validates :psn_name, :presence => true, :uniqueness => true, :length => { :maximum => 200 }
      
  has_many :teams, :through => :team_participations
  has_many :team_participations
  
  def to_s
    psn_name
  end
  
  def received_offers_count
    Offer.count(:id, :conditions => ['(team_id == ? and open == ? and originated_from_player = ?) or (user_id == ? and open == ? and originated_from_player = ?)', user_teams, true, true, id, true, false])
  end
  
  def sent_offers_count
    Offer.count(:id, :conditions => ['(user_id == ? and open == ? and originated_from_player = ?) or (team_id == ? and open == ? and originated_from_player = ?)', id, true, true, user_teams, true, false])
  end
  
  def can_create_offers?
    sent_offers_count < 10
  end
  
  def user_teams
    user_teams = []
    for team in Team.all
      if team.can_be_managed_by? self
        user_teams << team.id     
      end
    end
    user_teams
  end  
end
