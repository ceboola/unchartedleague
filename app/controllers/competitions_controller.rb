class CompetitionsController < ApplicationController
  load_and_authorize_resource

  def index
    @competitions = [Competition.find(2)]
    @entries = CompetitionEntry.where('competition_id = ?', 2)
    if user_signed_in? 
      #@signed_up_teams_ids = @entries.collect { |x| x.team.id }
      #@possible_teams = Team.joins(:team_participations).where("team_participations.user_id = ? and team_participations.role = ?", current_user.id, 0)
      #@possible_teams = @possible_teams.select { |x| not @signed_up_teams_ids.include? x.id }
    end
  end

  def new
    prepare_index
    @competition = Competition.new
  end

  def edit
    prepare_index
    @competition = Competition.find(params[:id])
  end

  def create
    @competition = Competition.new(params[:competition])
    if @competition.save
      flash[:success] = @competition.name + " created"
      redirect_to edit_competition_path(@competition)
    else
      flash[:error] = "Problem while saving"
      prepare_index
      render 'new'
    end
  end

  def update
    @competition = Competition.find(params[:id])
    if @competition.update_attributes(params[:competition])
      flash[:success] = @competition.name + " updated"
      redirect_to edit_competition_path(@competition)
    else
      flash[:error] = "Problem while saving changes"
      prepare_index
      render 'new'
    end
  end

  def destroy
    @competition = Competition.find(params[:id])
    if @competition.destroy
      flash[:success] = @competition.name + " destroyed!"
      redirect_to new_competition_path
    else
      flash[:error] = "Problem while destroying"
      prepare_index
      render 'new'
    end
  end

  private

  def prepare_index
    @competitions = Competition.all
  end
end
