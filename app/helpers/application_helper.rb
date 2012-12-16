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
    
    if unit == "komentarz" 
      if count == 1
        return "1 komentarz"
      elsif (count % 10 == 2 or count % 10 == 3 or count % 10 == 4) and (count <= 10 or count > 19)
        return "#{count} komentarze"
      else
        return "#{count} komentarzy"
      end
    end 
    
    if unit == "raz" 
      if count == 1
        return "1 raz"
      elsif (count % 10 == 2 or count % 10 == 3 or count % 10 == 4) and (count <= 10 or count > 19)
        return "#{count} razy"
      else
        return "#{count} razy"
      end
    end 
    pluralize(count, unit)
  end
  
  def one_line(sb)
    sb.gsub(/\n/, '').html_safe
  end

  def link_to_add_match_fields(name, f, teams, judges, competitions)
    new_match = Match.new(:locked_by_judge => false, :processed => false)
    fields = f.fields_for(:matches, new_match, :child_index => "new_match") do |builder|
      render("match_fields", :f => builder, :teams => teams, :judges => judges, :competitions => competitions)
    end
    link_to_function(name, "add_fields(this, \"match\", \"#{escape_javascript(fields)}\")")
  end
  
  def link_to_add_competition_entry_fields(name, f)
    new_entry = CompetitionEntry.new
    fields = f.fields_for(:competition_entries, new_entry, :child_index => "new_competition_entry") do |builder|
      render("competition_entry_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"competition_entry\", \"#{escape_javascript(fields)}\")")
  end
  
  def link_to_add_competition_judge_fields(name, f)
    new_judge = CompetitionJudge.new
    fields = f.fields_for(:competition_judges, new_judge, :child_index => "new_competition_judge") do |builder|
      render("competition_judge_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"competition_judge\", \"#{escape_javascript(fields)}\")")
  end
end
