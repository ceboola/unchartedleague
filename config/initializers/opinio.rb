# Opinio Configuration

Opinio.setup do |config|

  # Use this to change the class that calls +opinio+ method 
  config.model_name = "Comment"

  # This is the owner class of the comment (opinio model)
  config.owner_class_name = "User"

  # Change this if you do not want to allow replies on your comments
  config.accept_replies = false
  
  # Here you can change the method called to check who is the current user
  # config.current_user_method = :current_user

  config.interval_between_comments = 30
  config.destroy_conditions = Proc.new {
    can? :destroy, Comment
  }

  config.sort_order = 'ASC'
end
