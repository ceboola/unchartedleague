class Map < ActiveRecord::Base
  has_many :competition_maps, :dependent => :destroy
  validates :name, :presence => true
  validates :image_url, :presence => true
  
  def to_s
    name
  end
end
