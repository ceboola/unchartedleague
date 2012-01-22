class MatchEntry < ActiveRecord::Base
  belongs_to :match
  belongs_to :user
  belongs_to :team
end
