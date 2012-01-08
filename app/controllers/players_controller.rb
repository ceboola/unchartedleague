class PlayersController < ApplicationController
  def index
    @users = User.order("lower(psn_name) asc").paginate(:per_page => 20, :page => params[:page])
    if params[:team_invite_id]
      begin
        @team = Team.find(params[:team_invite_id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = t('teams.doesnt_exist')
      end
    end
  end
end
