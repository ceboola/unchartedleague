class AwardsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @awards = Award.order("created_at desc")
  end
  
  def new
    @award = Award.new
  end
  
  def create
    @award = Award.new(params[:award])
    if @award.save      
      flash[:success] = "Dodano"      
      redirect_to awards_path
    else
      flash[:error] = "Error"
      redirect_to new_award_path
    end
  end
  
  def edit
    @award = Award.find(params[:id])
  end
  
  def update
    @award = Award.find(params[:id])
    if @award.update_attributes(params[:award])
      flash[:success] = @award.name + " updated"
      redirect_to edit_award_path(@award)
    else
      flash[:error] = "Problem while saving changes"
      render @award
    end
  end
  
  def destroy
    @award = Award.find(params[:id])
      
    if @award.destroy
      flash[:success] = @award.name + " deleted"
      redirect_to awards_path
    else      
      flash[:error] = "Problem while deleting award"
      redirect_to awards_path  
    end
  end
end
