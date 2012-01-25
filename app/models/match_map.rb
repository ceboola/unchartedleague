class MatchMap < ActiveRecord::Base
  belongs_to :match
  belongs_to :map
  
  has_many :match_entries, :dependent => :destroy
end
