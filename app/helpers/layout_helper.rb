# encoding: utf-8

module LayoutHelper
  def info_section (text)
    span = content_tag(:span, nil, :style => 'float: left; margin-right: 0.3em;', :class => 'ui-icon ui-icon-info')    
    span << text.html_safe
    p = content_tag(:p, span, :style => 'padding: 3px')    
    div = content_tag(:div, p, :style => 'margin: 10px; padding: 1em; width: 800px;', :class => 'ui-state-highlight ui-corner-all')
    return div
  end
end
