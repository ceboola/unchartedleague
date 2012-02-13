# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "Liga Uncharted <hq@unchartedleague.com>"
  
  def new_match_time_proposal(proposal, receiving_team)
    @user = receiving_team.owner
    @proposal = proposal
    mail(:to => "miciek@gmail.com", :subject => "Nowa propozycja terminu meczu " + @user.email)
  end
  
  def match_time_accepted(match)    
    @match = match
    users = @match.team1.members + @match.team2.members
    users << @match.judge
    recipients = users.collect(&:email)
    mail(:to => recipients, :subject => "Termin meczu #{@match.team1.full_tag}-#{@match.team2.full_tag} został ustalony!")
  end
end
