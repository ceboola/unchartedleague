class PlayersController < ApplicationController
  def index
    @users = User.all
    if params[:team_invite_id]
      begin
        @team = Team.find(params[:team_invite_id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = t('teams.doesnt_exist')
      end
    end
  end
end
