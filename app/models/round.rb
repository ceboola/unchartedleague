class Round < ActiveRecord::Base
  belongs_to :competition
  has_many :matches

  accepts_nested_attributes_for :matches, :allow_destroy => true
  
  def name
    if round_name.present?
      round_name
    else
      "#{number}. #{I18n.t('matches.round_robin_round')}"
    end
  end
end
