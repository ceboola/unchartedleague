class TeamParticipation < ActiveRecord::Base 
  ROLES = %w(captain first_team reserve)
  
  belongs_to :user
  belongs_to :team

  validates :role, :presence => true, :inclusion => { :in => 0...ROLES.size }
  
  def role_name
    if role < ROLES.size then
      ROLES[role]
    else
      "N/A"
    end
  end
  
  def is_owner?
    role == 0
  end
end

