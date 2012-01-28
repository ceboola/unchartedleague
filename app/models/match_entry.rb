class MatchEntry < ActiveRecord::Base
  belongs_to :match_map
  belongs_to :user
  belongs_to :team
  
  validates :kills, :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0 }
end
