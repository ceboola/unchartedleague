class Award < ActiveRecord::Base
  default_scope order("importance desc")
  belongs_to :user
  belongs_to :team
  belongs_to :competition
  
  validates :name, :presence => true, :length => { :maximum => 20 }
  validates :icon_url, :presence => true
  validates :inline_icon_url, :presence => true
  validates :importance, :presence => true, :numericality => { :only_integer => true }
  
  def receiver
    unless team.nil?
      team.full_name
    else
      user.psn_name
    end
  end
  
  def full_name
    "#{name} - #{competition.long_name}"
  end
end
