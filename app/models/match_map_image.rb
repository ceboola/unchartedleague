class MatchMapImage < ActiveRecord::Base
  belongs_to :match_map
  belongs_to :user
end
