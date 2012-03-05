class Round < ActiveRecord::Base
  belongs_to :competition
  has_many :matches

  accepts_nested_attributes_for :matches
end
