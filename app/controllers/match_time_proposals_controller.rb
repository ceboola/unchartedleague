class MatchTimeProposalsController < ApplicationController
  def create
    proposal = MatchTimeProposal.new(params['match_time_proposal'])
    proposal.active = true
    if proposal.save
      UserMailer.new_match_time_proposal(proposal, (proposal.match.team1 == proposal.team ? proposal.match.team2 : proposal.match.team1)).deliver
      flash[:success] = t('matches.proposal_created_successfully')
      redirect_to proposal.match
    else
      if proposal.errors.any?
        flash[:error] = proposal.errors.first[1]
      else
        flash[:error] = t('matches.proposal_creation_error')
      end
      redirect_to proposal.match
    end
  end
  
  def update
    proposal = MatchTimeProposal.find(params[:id])
    if proposal.match.scheduled_at.nil?
      proposal.match.scheduled_at = proposal.proposal
      proposal.match.generate_match_maps
      if proposal.match.save
        UserMailer.match_time_accepted(proposal.match).deliver
        flash[:success] = t('matches.proposal_accepted_successfully')
        redirect_to proposal.match
      else
        flash[:error] = t('matches.cannot_accept_with_error')
        redirect_to matches_path
      end
    else
      flash[:error] = t('matches.cannot_accept_with_error')
      redirect_to matches_path
    end
  end
  
  def destroy
    proposal = MatchTimeProposal.find(params[:id])
    proposal.active = false
    if proposal.team.can_be_managed_by? current_user and proposal.save
      flash[:success] = t('matches.proposal_removed_successfully')
      redirect_to proposal.match
    else
      flash[:error] = t('matches.cannot_remove_proposal')
      redirect_to matches_path
    end
  end
end
