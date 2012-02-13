class Map < ActiveRecord::Base
  belongs_to :competition
  
  def to_s
    name
  end
end
