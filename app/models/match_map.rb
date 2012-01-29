class MatchMap < ActiveRecord::Base
  belongs_to :match
  belongs_to :map
  
  has_many :match_entries, :dependent => :destroy

  accepts_nested_attributes_for :match_entries, :reject_if => :entry_blank?
  
  def entry_blank? (attributes)
    attributes["kills"].blank? and attributes["deaths"].blank? and attributes["assists"].blank?    
  end
end
