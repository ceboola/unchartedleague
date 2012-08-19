class Comment < ActiveRecord::Base
  opinio
  paginates_per 3
end
