# encoding: utf-8

class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  validates :content, :presence => true, :length => { :maximum => 350 }
  
  def from
    if originated_from_player
      user
    else
      team
    end
  end
  
  def to
    if originated_from_player
      team
    else
      user
    end
  end
  
  def subject
    if originated_from_player
      "Prośba o dołączenie do #{team.name}"
    else
      "Zaproszenie do #{team.name}"
    end
  end
end
