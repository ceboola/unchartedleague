class MatchMapImagesController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    match_map = MatchMap.find(params[:match_map][:id])
    if params[:Filedata].present?
      if match_map.match.can_be_edited_by? current_user
        url = "/uploads/match_maps/" + upload(params[:Filedata], match_map.id.to_s)
        match_map.build_match_map_image(:user_id => current_user.id, :url => url)
        match_map.save
        render :text => url
      else
        render :text => "/uploads/match_maps/0.jpg"
      end
    end
  end
  
  private
  
  def upload(uploaded_io, fname)    
    fullname = fname + File.extname(uploaded_io.original_filename)
    File.open(Rails.root.join('public', 'uploads', 'match_maps', fullname), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    fullname
  end
end
