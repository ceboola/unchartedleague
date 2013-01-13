class Map < ActiveRecord::Base
  has_many :competition_maps, :dependent => :destroy
  
  def to_s
    name
  end
end
