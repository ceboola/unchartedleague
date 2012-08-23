module AwardsHelper  
  def name_with_award_image(obj, name = "")
    name = obj if name == ""
    if obj.awards.any?
       return "#{name} <img src='#{obj.awards[0].icon_url}' class='award' title='#{obj.awards[0].full_name}' />".html_safe
    end
    return "#{name}"
  end
end
