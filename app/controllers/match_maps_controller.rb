class MatchMapsController < ApplicationController
  def update
    @match_map = MatchMap.find(params[:id])
    @match_map.update_attributes(params[:match_map])
  end
end
