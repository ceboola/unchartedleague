class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :token_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :psn_name, :banned
  
  validates :psn_name, :presence => true, :uniqueness => true, :length => { :maximum => 200 }
      
  has_many :teams, :through => :team_participations
  has_many :team_participations
  has_many :offers, :dependent => :destroy
  has_many :awards, :dependent => :destroy
  
  def to_s
    psn_name
  end
  
  def avatar    
    hash = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar/#{hash}"
  end
  
  def self.custom_filter(params)
    if params[:show_without_team].present? and params[:show_without_team] == 'true'    
      includes(:team_participations).where('team_participations.team_id is null')
    else
      scoped
    end
  end  
end
