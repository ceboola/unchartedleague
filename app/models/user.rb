class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :teams, :through => :team_participations
  has_many :team_participations
  
  def to_s
    email
  end
  
  def received_offers_count
    Offer.count(:id, :conditions => ['(team_id == ? and open == ? and originated_from_player = ?) or (user_id == ? and open == ? and originated_from_player = ?)', user_teams, true, true, id, true, false])
  end
  
  def sent_offers_count
    Offer.count(:id, :conditions => ['(user_id == ? and open == ? and originated_from_player = ?) or (team_id == ? and open == ? and originated_from_player = ?)', id, true, true, user_teams, true, false])
  end
  
  def can_create_offers?
    sent_offers_count < 2
  end
  
  def user_teams
    if not @user_teams
      refresh_user_teams
    else
      @user_teams
    end
  end
  
  def refresh_user_teams
    @user_teams = []
    for team in Team.all
      if team.can_be_managed_by? self
        user_teams << team.id     
      end
    end
  end
end
