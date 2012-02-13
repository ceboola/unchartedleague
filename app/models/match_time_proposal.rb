# encoding: utf-8
class DateAheadValidator < ActiveModel::Validator
  def validate(record)
    unless record.proposal.future?
      record.errors[:base] << 'Propozycja musi dotyczyć przyszłości!'
    end
  end
end

class MatchTimeProposal < ActiveRecord::Base  
  default_scope where('active = ?', true).order('proposal asc')
  
  belongs_to :match
  belongs_to :team
  
  validates :proposal, :date_ahead => true
end
