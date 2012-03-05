class RoundsController < ApplicationController  
  load_and_authorize_resource

  def create    
    @round = Round.new(params[:round])
    if @round.save
      flash[:success] = "OK"
      redirect_to matches_path
    else
      flash[:error] = "NOOOO!!!"
      redirect_to new_round_path
    end
  end
  
  def new
    judge_ids = Match.select('DISTINCT judge_id').collect {|x| x.judge_id}
    @judges = User.find(judge_ids)
    @teams = Team.all

    @round = Round.new
    used_teams = []
    @logs = []
    for c in Competition.find([3,4]) do
      for t in c.teams
        @logs << "analyzing team #{t}"
        unless used_teams.include? t
          @logs << "is not in used_team"
          played_with = [t] + used_teams
          for m in Match.where('(team1_id = ? or team2_id = ?) and competition_id = ?', t.id, t.id, c.id)
            if m.team1 == t
              played_with << m.team2
            end
            if m.team2 == t
              played_with << m.team1
            end
          end
          @logs << "played with teams: #{played_with.collect {|x| x.name } }"
          possible = c.teams - played_with
          @logs << "possible opponents: #{possible.collect {|x| x.name }}"
          for opp in possible.shuffle
            team2 = opp
            break
          end
          @logs << "new match: #{t}-#{team2}"
          @round.matches.build(:team1_id => t.id, :team2_id => team2.id, :locked_by_judge => false, :processed => false, :competition_id => c.id)
          used_teams << t
          used_teams << team2
        end
      end
    end
  end
end
