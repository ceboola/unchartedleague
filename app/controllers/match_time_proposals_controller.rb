class MatchTimeProposalsController < ApplicationController
  def create
    proposal = MatchTimeProposal.new(params['match_time_proposal'])
    if proposal.save
      flash[:success] = t('matches.proposal_created_successfully')
      redirect_to proposal.match
    else
      flash[:error] = t('matches.proposal_creation_error')
      redirect_to root
    end
  end
  
  def update
    proposal = MatchTimeProposal.find(params[:id])    
    proposal.match.scheduled_at = proposal.proposal
    proposal.match.generate_match_maps
    if proposal.match.save
      flash[:success] = t('matches.proposal_accepted_successfully')
      redirect_to proposal.match
    else
      flash[:error] = t('matches.cannot_accept_with_error')
      redirect_to root
    end
  end
  
  def destroy
    proposal = MatchTimeProposal.find(params[:id])
    if proposal.team.can_be_managed_by? current_user and proposal.destroy
      flash[:success] = t('matches.proposal_removed_successfully')
      redirect_to proposal.match
    else
      flash[:error] = t('matches.cannot_remove_proposal')
      redirect_to root
    end
  end
end
