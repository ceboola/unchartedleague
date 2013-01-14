class UsersController < ApplicationController
  def index
    @users = User.custom_filter(params).order("lower(psn_name) asc").page(params[:page])
    if params[:team_invite_id]
      begin
        team = Team.find(params[:team_invite_id])
        if team.can_be_managed_by? current_user
          @team = team
        else
          flash[:alert] = t('teams.cannot_manage')
        end
      rescue ActiveRecord::RecordNotFound        
        flash[:alert] = t('teams.doesnt_exist')
      end
    end
  end
   
  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /users/1
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to users_path, notice: 'User was successfully updated.'        
    else
      render action: "edit"       
    end
  end
end
