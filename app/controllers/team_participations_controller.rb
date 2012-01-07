class TeamParticipationsController < ApplicationController
  def destroy    
    begin
      tp = TeamParticipation.find(params[:id])
      team = tp.team
      if not tp.is_owner? 
        if tp.destroy
          flash[:success] = t('players.removed_successfully')
          redirect_to team_path(team)
        else
          flash[:error] = t('players.cannot_remove')
          redirect_to teams_path
        end
      else
        flash[:error] = t('players.cannot_remove_owner')
        redirect_to team_path(team)
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('players.doesnt_exist')
      redirect_to teams_path
    end
  end
end
