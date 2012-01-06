module ApplicationHelper
  def logo
    image_tag asset_path("logo.png"), :alt => "Uncharted League"
  end
end
