class MatchesController < ApplicationController
  def index
    if not current_user.nil? and params[:show_my].present? and params[:show_my] == 'true'
      user = current_user
    else
      user = nil
    end
    @matches = Match.filtered(user).order("scheduled_at asc").paginate(:per_page => 20, :page => params[:page])    
    @competition = Competition.find(1)
    if user_signed_in?
      teams = Team.joins(:competitions, :team_participations).where("user_id = ? and role = ? and competitions.id = ?", current_user.id, 0, 1)
      if teams.empty?
        @managed_team = nil
      else
        @managed_team = teams[0]
        @match = Match.new
        @match.team1 = @managed_team
        @match.competition = @competition
      end
    end
  end
  
  def show
    @match = Match.find(params[:id])
  end
  
  def create    
    @match = Match.new(params[:match])
    @match.processed = false
    if @match.save
      flash[:success] = t('matches.proposal_created_successfully')
      redirect_to matches_path
    else       
      render :action => 'index'
    end  
  end
  
  def update
    begin
      @match = Match.find(params[:id])
      @team2 = Team.find(params[:team2_id])
      if @match.open_spot? and @team2.can_be_managed_by? current_user
        @match.team2 = @team2
        # @match.judge = User.find(1)
        generate_maps(@match)
        if @match.save
          flash[:success] = t('matches.proposal_accepted_successfully')
          redirect_to match_path @match
        else      
          flash[:error] = t('matches.cannot_accept_with_error') + "2"
          redirect_to matches_path  
        end
      else
        flash[:error] = t('matches.cannot_accept')
        redirect_to matches_path
      end
    rescue Exception
      flash[:error] = t('matches.cannot_accept_with_error') + "1"
      redirect_to matches_path
    end
  end
  
  def destroy
    begin
      @match = Match.find(params[:id])
      if @match.open_spot? and @match.team1.can_be_managed_by? current_user 
        if @match.destroy
          flash[:success] = t('matches.proposal_removed_successfully')
          redirect_to matches_path
        else      
          flash[:error] = t('matches.cannot_remove_with_error')
          redirect_to matches_path  
        end
      else
        flash[:error] = t('matches.cannot_remove')
        redirect_to matches_path
      end
    rescue Exception
      flash[:error] = t('matches.cannot_remove_with_error')
      redirect_to matches_path
    end
  end
  
  private
  
  def generate_maps(match)
    
  end
end
