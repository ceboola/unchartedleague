class TeamParticipationsController < ApplicationController
  def destroy    
    begin      
      tp = TeamParticipation.find(params[:id])      
      team = tp.team
      if team.can_be_managed_by? current_user or tp.user == current_user
        if not tp.is_owner? 
          if tp.destroy
            if tp.user == current_user
              flash[:success] = t('players.left_team_successfully')
            else
              flash[:success] = t('players.removed_successfully')
            end
            redirect_to team_path(team)
          else
            flash[:error] = t('players.cannot_remove')
            redirect_to teams_path
          end
        else
          flash[:error] = t('players.cannot_remove_owner')
          redirect_to team_path(team)
        end
      else
        flash[:error] = t('teams.cannot_manage')
        redirect_to team_path(team)
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('players.doesnt_exist')
      redirect_to teams_path
    end
  end
  
  def edit
    @tp = TeamParticipation.find(params[:id])
    @available_roles = TeamParticipation::ROLES.collect { |r| [r, TeamParticipation::ROLES.index(r)] }.select { |x| x[1] != @tp.role }    
  end
  
  def update
    begin 
      tp = TeamParticipation.find(params[:id])
      if tp.team.can_be_managed_by? current_user
        if tp.is_owner?          
          new_owner = User.find(params[:user][:id])
          if tp.team.members.include? new_owner
            new_owner_tp = tp.team.member_participation new_owner
            process_new_owner(new_owner_tp, params[:team_participation][:role])
          end
        else          
          if params[:team_participation][:role] == "0"
            process_new_owner(tp, 1)
          else
            tp.update_attributes params[:team_participation]
            if tp.save!
              @tp = tp
            end
          end
        end
      end
    rescue Exception      
    end
  end
  
  private
  
  def process_new_owner(tp, old_owner_role)
    TeamParticipation.transaction do
      owner_tp = tp.team.owner_participation
      owner_tp.role = old_owner_role
      tp.role = 0
      if tp.save! and owner_tp.save!
        @tp = tp                
        @owner_tp = owner_tp
      end
    end
  end
end
