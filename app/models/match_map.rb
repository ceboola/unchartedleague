class MatchMap < ActiveRecord::Base
  belongs_to :match
  belongs_to :map
  
  has_many :match_entries, :dependent => :destroy, :autosave => true
  
  validates_associated :match_entries
  accepts_nested_attributes_for :match_entries
end
