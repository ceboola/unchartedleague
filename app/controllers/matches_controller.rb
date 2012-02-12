class MatchesController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def index
    if not current_user.nil? and params[:show_my].present? and params[:show_my] == 'true'
      @matches3 = Match.filtered(current_user).where("competition_id = ?", 3).order("scheduled_at asc").paginate(:per_page => 20, :page => params[:page])    
    elsif not current_user.nil? and params[:show_judged].present? and params[:show_judged] == 'true'
      @matches3 = Match.where("judge_id = ? and competition_id = ?", current_user.id, 3).order("scheduled_at asc").paginate(:per_page => 20, :page => params[:page])        
    else
      @matches3 = Match.where("competition_id = ?", 3).order("scheduled_at desc").paginate(:per_page => 20, :page => params[:page])    
    end
    
    if not current_user.nil? and params[:show_my].present? and params[:show_my] == 'true'
      @matches4 = Match.filtered(current_user).where("competition_id = ?", 4).order("scheduled_at asc").paginate(:per_page => 20, :page => params[:page])    
    elsif not current_user.nil? and params[:show_judged].present? and params[:show_judged] == 'true'
      @matches4 = Match.where("judge_id = ? and competition_id = ?", current_user.id, 4).order("scheduled_at asc").paginate(:per_page => 20, :page => params[:page])        
    else
      @matches4 = Match.where("competition_id = ?", 4).order("scheduled_at desc").paginate(:per_page => 20, :page => params[:page])    
    end
    
    @matches = @matches3 + @matches4
    
    @competition = Competition.find(2)
    if user_signed_in?
      teams = Team.joins(:competitions, :team_participations).where("user_id = ? and role = ? and competitions.id = ?", current_user.id, 0, 2)
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
    @edit_mode = (user_signed_in? and ((not @match.processed) and (current_user == @match.judge)) or ((not @match.processed) and (not @match.locked_by_judge) and (@match.team1.has_member? current_user or @match.team2.has_member? current_user)))
    if @edit_mode
      for match_map in @match.match_maps do
        for team in @match.teams        
          max = team.all_users.size
          max = @match.competition.max_players_per_team if max > @match.competition.max_players_per_team
          existing = match_map.match_entries.select { |x| x.team == team }.collect { |x| x.user.id }
          team.all_users.select { |x| not existing.include? x.id }.slice(0...(max - existing.size)).each do |x| 
            match_map.match_entries.build(:team_id => team.id, :match_id => @match.id, :user_id => x.id)
          end
        end
      end    
    end
  end
  
  def create    
    @match = Match.new(params[:match])
    @match.processed = false
    @match.locked_by_judge = false
    if @match.save
      flash[:success] = t('matches.proposal_created_successfully')
      redirect_to matches_path
    else       
      render :action => 'index'
    end  
  end
  
  def update
    #begin
      @match = Match.find(params[:id])
      @team2 = Team.find(params[:team2_id])
      if @match.open_spot? and @team2.can_be_managed_by? current_user
        @match.team2 = @team2
        # @match.judge = User.find(1)
        @match.generate_match_maps
        if @match.save
          flash[:success] = t('matches.proposal_accepted_successfully')
          redirect_to match_path @match
        else      
          flash[:error] = t('matches.cannot_accept_with_error') 
          redirect_to matches_path  
        end
      else
        flash[:error] = t('matches.cannot_accept')
        redirect_to matches_path
      end
    #rescue Exception
      #flash[:error] = t('matches.cannot_accept_with_error')
      #redirect_to matches_path
    #end
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
  
  def check_results    
    @match = Match.find(params[:id])
    @match.locked_by_judge = true
    @match.save!
  end
  
  def commit_results    
    match = Match.find(params[:id])
    if current_user == match.judge
      match.processed = true
      if match.save
        flash[:success] = t('matches.results_commited_successfully')
        redirect_to match
      else
        flash[:success] = t('matches.results_commit_error')
        redirect_to matches_path
      end
    end
  end
end
