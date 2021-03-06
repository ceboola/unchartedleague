class OffersController < ApplicationController
  before_filter :authenticate_user!

  def index        
    @sent = Offer.sent_offers current_user
    @received = Offer.received_offers current_user
  end
  
  def new    
    if Offer.can_create_offers? (current_user)
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
        UserMailer.offer_sent(@offer).deliver
        flash[:success] = t('offers.sent_successfully')
        redirect_to :action => 'index'
      else       
        render :action => 'new'
      end      
    else
      flash[:error] = t('offers.cannot_send')
      redirect_to offers_path
    end
  end
  
  def show
    begin
      @offer = Offer.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('offers.doesnt_exist')
      redirect_to offers_path
    end
  end
  
  def update
    begin
      @offer = Offer.find(params[:id])      
      if @offer.is_sane?      
        if params[:accept]          
          if @offer.accept
            flash[:success] = t('offers.accepted')
            redirect_to team_path @offer.team            
          else
            cannot_process_offer @offer
          end          
        elsif params[:reject]          
          if @offer.reject
            flash[:success] = t('offers.rejected')
            redirect_to offers_path
          else
            cannot_process_offer @offer
          end
        elsif params[:remove]         
          if @offer.close
            flash[:success] = t('offers.removed')
            redirect_to offers_path
          else
            cannot_process_offer @offer
          end       
        else
          cannot_process_offer @offer
        end
      else
        @offer.close
        flash[:alert] = t('offers.is_not_sane')
        redirect_to offers_path
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('offers.doesnt_exist')
      redirect_to offers_path
    end
  end
  
  private 
  
  def cannot_process_offer(offer)
    flash[:error] = t('offers.cannot_process')
    redirect_to offer_path offer      
  end
end
