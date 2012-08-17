module PublicHelper
  def show_tab(tab)
    link_to raw("<span><span>#{tab.name}</span></span>"), url_for(tab.link), tab.options.merge(:class => tab.is_highlighted?(params) ? "selected" : nil) 
  end
  def set_flash_messages_variable(flash)
    json = {}
    flash.each do |key,msg|
      json[key] = msg
    end
    javascript_tag do 
      raw "flash_messages = #{json.to_json}"
    end
  end
end
