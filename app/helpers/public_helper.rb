module PublicHelper
  def show_tab(tab)
    link_to raw("<span><span>#{tab.name}</span></span>"), url_for(tab.link), tab.options.merge(:class => tab.is_highlighted?(params) ? "selected" : nil) 
  end
end
