class CompetitionEntriesController < ApplicationController
  def create    
    if params[:competition_id] and params[:team_id]
      begin
        competition = Competition.find(params[:competition_id])
        team = Team.find(params[:team_id])
        if competition.can_team_be_signed_up? team
          wrong_user = nil
          for user in team.users
            if competition.is_user_signed_up? user
              wrong_user = user
              break
            end
          end
          if wrong_user.nil?
            entry = CompetitionEntry.new(:team_id => team.id, :competition_id => competition.id)
            if entry.save!
              flash[:success] = t('competitions.signed_up_successfully')
              redirect_to competitions_path
            else
              send_error
            end
          else
            send_error " #{t('competitions.user_already_signed_up', :user => wrong_user)}"
          end
        else
          send_error " #{t('competitions.team_too_small')}"
        end
      rescue ActiveRecord::RecordNotFound
        send_error
      end
    else
      send_error
    end
  end
  
  private
  
  def send_error (message = "")
    flash[:error] = t('competitions.sign_up_error') + message
    redirect_to competitions_path
  end
end
