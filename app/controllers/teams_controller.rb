class TeamsController < ApplicationController  
  def index
    # FIXME: active record + paging
    
    teams = Team.all
    user_teams = []
    for team in teams
      if team.has_member? current_user
        user_teams << team        
      end
    end
    
    for team in user_teams
      teams.delete(team)
    end
    
    @teams = user_teams + teams
  end

  def show
    begin
      @team = Team.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('teams.doesnt_exist')
      redirect_to teams_path
    end
  end

  def new
    @team = Team.new
  end
  
  def create    
    @team = Team.new(params[:team])
    tp = @team.team_participations.build
    tp.user = current_user
    tp.team = @team
    tp.role = TeamParticipation::ROLES.index('owner')    
    if @team.save
      flash[:success] = t('teams.created_successfully')
      redirect_to team_path(@team)
    else       
      render :action => 'new'
    end  
  end

  def edit
  end

  def destroy
    begin
      @team = Team.find(params[:id])
      if @team.destroy
        flash[:success] = t('teams.removed_successfully')
        redirect_to teams_path
      else      
        render :action => 'show'    
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('teams.doesnt_exist')
      redirect_to teams_path
    end
  end
end
