# encoding: utf-8

module ApplicationHelper
  def logo
    image_tag asset_path("logo.png"), :alt => "Uncharted League"
  end
  
  def pluralize_localized(count, unit)
    if unit == "błąd" 
      if count == 1
        return "1 błąd"
      elsif (count % 10 == 2 or count % 10 == 3 or count % 10 == 4) and (count <= 10 or count > 19)
        return "#{count} błędy"
      else
        return "#{count} błędów"
      end
    end   
    
    if unit == "propozycja" 
      if count == 1
        return "1 propozycja"
      elsif (count % 10 == 2 or count % 10 == 3 or count % 10 == 4) and (count <= 10 or count > 19)
        return "#{count} propozycje"
      else
        return "#{count} propozycji"
      end
    end 
    pluralize(count, unit)
  end
  
  def one_line(sb)
    sb.gsub(/\n/, '').html_safe
  end
end
