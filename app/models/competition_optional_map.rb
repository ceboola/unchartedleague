class CompetitionOptionalMap < ActiveRecord::Base
  belongs_to :competition
  belongs_to :map
end
