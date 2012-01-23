class MatchEntry < ActiveRecord::Base
  belongs_to :match_map
  belongs_to :user
  belongs_to :team
end
