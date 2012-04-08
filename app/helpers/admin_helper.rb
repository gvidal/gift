module AdminHelper
  def title_page(title = nil)
    title ||= t('title', :scope => ["admin", params[:controller], params[:action]])
    content_tag(:div, content_tag(:h2, title), :class => "title_wrapper")
  end
end
