class Comment < ActiveRecord::Base
  opinio
  paginates_per 20
end
