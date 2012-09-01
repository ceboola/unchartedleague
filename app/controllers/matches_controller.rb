class MatchesController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def index_current_NOTUSED #TODO: add format support for competition (open/scheduled)
    active_competitions = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11] # FIXME
    
    if not current_user.nil? and params[:show_my].present? and params[:show_my] == 'true'
      @matches = Match.filtered(current_user).where("competition_id in (?)", active_competitions).order("scheduled_at desc").paginate(:per_page => 20, :page => params[:page])    
    elsif not current_user.nil? and params[:show_judged].present? and params[:show_judged] == 'true'
      @matches = Match.where("judge_id = ? and competition_id in (?)", current_user.id, active_competitions).order("scheduled_at desc").paginate(:per_page => 20, :page => params[:page])        
    else
      @rounds = Round.where("competition_id in (?)", active_competitions).order("number desc, competition_id asc")
    end
  end
  
  def index
    if not current_user.nil? and params[:show_my].present? and params[:show_my] == 'true'
      user = current_user
    else
      user = nil
    end    
    @competition = Competition.find(12) # FIXME
    active_competitions = [12] # FIXME
    if not current_user.nil? and params[:show_judged].present? and params[:show_judged] == 'true'
      @matches = Match.where("judge_id = ? and competition_id in (?)", current_user.id, active_competitions).order("scheduled_at asc")    
    else
      @matches = Match.where('competition_id = ?', @competition.id).filtered(user).order("scheduled_at asc")  
    end
    
    if user_signed_in?
      teams = Team.joins(:competitions, :team_participations).where("user_id = ? and role = ? and competitions.id = ?", current_user.id, 0, @competition.id)
      @managed_team = nil
     
      for t in teams
        if @competition.teams.include? t
          @managed_team = t
          @match = Match.new
          @match.team1 = @managed_team
          @match.competition = @competition
          break
        end
      end      
    end
  end
  
  def show    
    @match = Match.find(params[:id])
    
    if @match.scheduled_at.nil? 
      if user_signed_in?
        teams = Team.joins(:competitions, :team_participations).where("user_id = ? and role = ? and competitions.id = ? and (teams.id = ? or teams.id = ?)", current_user.id, 0, 2, @match.team1.id, @match.team2.id)
        if teams.empty?
          @managed_team = nil
        else
          @managed_team = teams[0]          
        end
     end
    end
    
    @edit_mode = (user_signed_in? and (not @match.scheduled_at.nil?) and (((not @match.processed) and (current_user == @match.judge)) or ((not @match.processed) and (not @match.locked_by_judge) and (@match.team1.has_member? current_user or @match.team2.has_member? current_user))))
    if @edit_mode
      for match_map in @match.match_maps do # FIXME: merge with MatchMapsController
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
      flash[:success] = t('matches.proposal_created_successfully_without_opponent')
      redirect_to matches_path
    else       
      render :action => 'index'
    end  
  end
  
  def update 
    @match = Match.find(params[:id])    
    if params[:team2_id].present? # merge with MatchTimeProposal?
      @team2 = Team.find(params[:team2_id])
      if @match.open_spot? and @team2.can_be_managed_by? current_user
        @match.team2 = @team2
        @match.judge = @match.competition.get_judge
        @match.generate_match_maps
        if @match.save
          UserMailer.match_time_accepted(@match).deliver
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
    else # normal update by judge or admin
      if current_user == @match.judge or can? :manage, @match
        if params[:match].present?
          if @match.update_attributes(params[:match])
            flash[:success] = "Mecz zaktualizowany"            
          else
            flash[:error] = "Problem podczas zapisu. Prosimy o kontakt z administratorem."
          end          
        elsif params[:remove_all_results]
          for entry in @match.match_entries
            entry.destroy
          end
          flash[:success] = "Wyniki wyczyszczone."     
        end
        redirect_to match_path(@match)
      end
    end
  end
  
  def destroy
    begin
      @match = Match.find(params[:id])
      if @match.open_spot? and (can?(:destroy, @match) or @match.team1.can_be_managed_by? current_user)
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
    
    # TODO, move this section to somewhere else
    @competition_players = {}
    @competition_players[@match.team1] = Set.new
    @competition_players[@match.team2] = Set.new
    for team in @match.teams do      
      for match in Match.where('(team1_id = ? or team2_id = ?) and competition_id = ?', team.id, team.id, @match.competition_id) do #FIXME (nearly the same as teams_controller        
        for entry in match.match_entries          
          if entry.team == team            
            @competition_players[team].add entry.user
          end
        end
      end
    end    
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
