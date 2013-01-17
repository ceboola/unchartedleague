class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :banned?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def banned?
    if current_user.present? and current_user.banned?
      sign_out current_user
      flash[:error] = I18n.t('users.banned')
      redirect_to root_path
    end
  end
end
