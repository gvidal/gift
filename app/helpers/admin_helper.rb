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
  def token_input(form, relation, options = {})
    object = form.object
    association_type = object.association(relation).reflection.macro
    limit = 0.0/0.0 #NaN
    relation_token_method = ""
    options[:data] ||= {}
    options[:token_id] ||= :id
    options[:token_name] ||= :name
    case association_type
      when :has_one, :belongs_to
        limit = 1
        relation_token_method = (relation.to_s + "_token").to_sym
        rel = f.object.send(relation)
        if rel
          options[:load] ||= [:name => rel.send(options[:token_name]), 
                                      :id => rel.send(options[:token_id])]
        else
          options[:load] ||= []
        end
        
      else
        relation_token_method = (relation.to_s + "_tokens").to_sym
        object.class.validators.each do |validator|
          if validator.attributes.include?(relation) || validator.attributes.include?((relation.to_s.singularize + "_ids").to_sym)
            if validator.class.name == "ActiveModel::Validations::LengthValidator" && validator.options[:maximum].present?
              limit = validator.options[:maximum]
            end  
          end
        end
       options[:load] ||= f.object.send(relation).map{|r|
                                                  [:id => r.send(options[:token_id]), :name => r.send(options[:token_name])]}
    end
    options[:token_href] ||= "admin_#{relation.to_s.tableize}_url"
    options[:data].reverse_merge({:load => options[:load],
                                  :limit => limit.to_f.nan? ? nil : limit.to_i,
                                  :href => options[:token_href]})
    raw f.text_field(relation_token_method, 
                     options.merge(:class => "token-input-text",
                                   :data => options[:data]))
  end
  
end
