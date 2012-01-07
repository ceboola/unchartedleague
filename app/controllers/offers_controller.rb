class OffersController < ApplicationController
  def index        
    @sent = Offer.where('(user_id == ? and open == ? and originated_from_player = ?) or (team_id == ? and open == ? and originated_from_player = ?)', current_user.id, true, true, current_user.user_teams, true, false)    
    @received = Offer.where('(team_id == ? and open == ? and originated_from_player = ?) or (user_id == ? and open == ? and originated_from_player = ?)', current_user.user_teams, true, true, current_user.id, true, false)
  end
  
  def new    
    if current_user.can_create_offers?
      if params[:user_id] and params[:team_id] and params[:originated_from_player]
        @offer = Offer.new(params.slice(:user_id, :team_id, :originated_from_player))      
      else
        flash[:error] = t('offers.cannot_send')
        redirect_to offers_path
      end
    else
      flash[:error] = t('offers.too_many_open_offers')
      redirect_to offers_path
    end
  end
  
  def create
    if params[:user_id] and params[:team_id] and params[:originated_from_player]
      @offer = Offer.new(params.slice(:user_id, :team_id, :originated_from_player, :content))
      @offer.open = true
      @offer.accepted = false
      if @offer.save
        flash[:success] = t('offers.sent_successfully')
        render :action => 'index'
      else       
        render :action => 'new'
      end      
    else
      flash[:error] = t('offers.cannot_send')
      redirect_to offers_path
    end
  end
end
