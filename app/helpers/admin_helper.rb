module AdminHelper
  def title_page(title = nil)
    content_tag(:div, content_tag(:h2, title || general_title), :class => "title_wrapper")
  end
  def head_tabs
    content_tag(:ul) do
      a = ""
      ADMIN_TABS.each do |tab|
        a += content_tag(:li, :id => "", :class => "") do
          tab_title = I18n.t(tab.tab[:controller].split('/').last,:scope => ['admin', 'tabs','main_tabs'])
          content = link_to(content_tag(:span, 
                              content_tag(:span, tab_title)), url_for(tab.tab), 
                              {:class => (params[:controller] == tab.tab[:controller]) ? "selected" : ""})
          content += head_subtitles(tab.subtabs)
          raw content
        end
      end
      raw a
    end
  end
  def head_subtitles(subtabs)
    if subtabs.map{|x| x[:controller]}.include?(params[:controller])
      content_tag(:ul) do
        a = ""
        subtabs.each do |subtab|
          a += content_tag(:li) do
            link_to(raw("<span><span>#{I18n.t(subtab[:controller].split('/').last, :scope => ['admin', 'tabs','subtabs'])}</span></span>"), 
                    url_for(subtab), 
                    :class => (params[:controller] == subtab[:controller]) ? "selected" : "")
          end
        end
        raw a
      end
    else
      ""
    end
  end
  def general_title
    t('title', :scope => ["admin", "views",params[:controller].split('/').last, params[:action]])
  end
end
