class MatchEntry < ActiveRecord::Base
  belongs_to :match_map
  belongs_to :user
  belongs_to :team
  
  validates :kills, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0 }, :if => :entry_present?
  validates :deaths, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0 }, :if => :entry_present?
  validates :assists, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0 }, :if => :entry_present?
 
  def entry_present?
    kills.present? or deaths.present? or assists.present?
  end
end
