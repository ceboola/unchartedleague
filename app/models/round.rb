class Round < ActiveRecord::Base
  belongs_to :competition
  has_many :matches
end
