class RoundsController < ApplicationController  
  load_and_authorize_resource

  def create    
    @round = Round.new(params[:round])
    if @round.save
      for m in @round.matches
        UserMailer.new_match_added(m).deliver
      end
      flash[:success] = "OK"      
      redirect_to matches_path
    else
      flash[:error] = "NOOOO!!!"
      redirect_to new_round_path
    end
  end
  
  def new
    @judges = CompetitionJudge.where("competition_id = ?", 13).collect { |x| x.user }
    @teams = Team.all

    @round = Round.new
    used_teams = []
    for c in Competition.find([14,15]) do
      for t in c.teams
        unless used_teams.include? t
          played_with = [t] + used_teams
          for m in Match.where('(team1_id = ? or team2_id = ?) and competition_id = ?', t.id, t.id, c.id)
            if m.team1 == t
              played_with << m.team2
            end
            if m.team2 == t
              played_with << m.team1
            end
          end
          possible = c.teams - played_with
          for opp in possible.shuffle
            team2 = opp
            break
          end
          unless team2.nil?
            @round.matches.build(:team1_id => t.id, :team2_id => team2.id, :locked_by_judge => false, :processed => false, :competition_id => c.id)
          end
          used_teams << t
          used_teams << team2
        end
      end
    end
  end
end
