class MatchTimeProposal < ActiveRecord::Base
  default_scope order('proposal asc')
  
  belongs_to :match
  belongs_to :team
end
