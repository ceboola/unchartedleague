class TeamsController < ApplicationController  
  def index
    if not current_user.nil? and params[:show_my].present? and params[:show_my] == 'true'
      user = current_user
    else
      user = nil
    end
    @teams = Team.user_teams(user).order("lower(name) asc").paginate(:per_page => 20, :page => params[:page])    
  end

  def show
    begin
      @team = Team.find(params[:id])
      @team_participations = TeamParticipation.where("team_id = ?", @team.id).order("role asc")
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('teams.doesnt_exist')
      redirect_to teams_path
    end
  end

  def new
    authenticate_user!
    @team = Team.new    
  end
  
  def create    
    @team = Team.new(params[:team])
    tp = @team.team_participations.build
    tp.user = current_user
    tp.team = @team
    tp.role = TeamParticipation::ROLES.index('captain')
    tp.active = true
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
      if @team.can_be_managed_by? current_user
        if @team.competition_entries.empty? and @team.destroy
          flash[:success] = t('teams.removed_successfully')
          redirect_to teams_path
        else      
          flash[:error] = t('teams.cannot_be_deleted')
          redirect_to :action => 'show'    
        end
      else
        flash[:error] = t('teams.cannot_manage')
        redirect_to team_path @team
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('teams.doesnt_exist')
      redirect_to teams_path
    end
  end
end
