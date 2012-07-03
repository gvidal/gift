module AdminHelper
  
 def link_to_add_variant_image_fields(name, f)
    association = :variant_images
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("admin/variants/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_variant_image_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
  def title_page(title = nil)
    content_tag(:div, content_tag(:h2, title || general_title), :class => "title_wrapper")
  end
  
  
  def product_sidebar(product)
    selected = case params[:controller]
    when "admin/products"
      0
    when "admin/variants"
      1
    else
      nil
    end
    links = [
      link_to(Product.model_name.human, [:edit,:admin, product]),
      link_to(Variant.model_name.human, [:admin, product, :variants])]
    render :partial => "admin/shared/sidebars/links", 
             :locals => {:object => Product,
                          :link_collection => links,
                          :selected => selected}
  end
  
  def show_tab(tab)
    link_to raw("<span><span>#{tab.name}</span></span>"), url_for(tab.link), tab.options.merge(:class => tab.is_highlighted?(params) ? "selected" : nil) 
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
  
  def render_tabs(tab_info)
    render partial: tab_info.partial, locals: tab_info.locals
  end
  
  def admin_text_field(form, method, options= {})
    content_tag(:div, :class => "row") do
      a = form.label form.object.class.human_attribute_name(method)
      codes = ["<strong>B</strong>", "<i>i</i>", "u", "Code", "List", "List=", "[*]", "URL", "Img"]
      a += content_tag(:div, :class => 'inputs') do
        b = ""
        b += content_tag(:ul, :class => "mc_menu") do
          c = ""
          codes.each do |code|
            c += content_tag(:li, link_to(raw(code), "#"))
          end
          raw c
        end
        b += content_tag(:span, form.text_area(method, options),:class =>  "input_wrapper textarea_wrapper" )
        raw b
       end
       raw a
    end
  end
  
  def admin_date_time_picker(form, method, options = {})
    content_tag(:div, :class => "row") do
      a = form.label method, form.object.class.human_attribute_name(method)
      a += content_tag(:div, :class => "inputs") do
        format = I18n.t(options.delete(:format) || "default",:scope => 'time.datepicker_js_formats'.split("."))
        date_format = format[:date]
        time_format = format[:time]
        date = form.object.send(method)
        method_value = date.nil? ? date : date.strftime(I18n.t(options.delete(:format) || "default",:scope => 'time.datepicker_formats'.split(".")))
        content_tag(:span, form.text_field(method, 
                                          options.merge(:class => "text datetimepicker", :value => method_value, 
                                                         :data => {date_format: date_format,
                                                                   time_format: time_format})))
      end
      raw(a)
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
    options[:search_method] ||= "tokens"
    options[:wrap_word] = (options.key?(:wrap_word) ? options[:wrap_word] : "search")
    options[:other_search_methods] ||= {}
    options[:html] ||= {}
    case association_type
      when :has_one, :belongs_to
        limit = 1
        relation_token_method = (relation.to_s + "_token").to_sym
        rel = form.object.send(relation)
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
       options[:load] ||= form.object.send(relation).map{|r|
                                                  {id: r.send(options[:token_id]), name: r.send(options[:token_name])}}
    end
    options[:token_href] ||= send("admin_#{relation.to_s.tableize}_url") 
    data  = options[:data].reverse_merge({:load => options[:load],
                                  :limit => limit.to_f.nan? ? nil : limit.to_i,
                                  :href => options[:token_href],
                                  :queryparam => options[:search_method],
                                  :wrapparam => options[:wrap_word],
                                  :queryOtherMethods => options[:other_search_methods]})
                              
    raw form.text_field(relation_token_method, 
                     options[:html].merge(:class => "token-input",:data => data))
  end
  
  def media_file_attachment(form, options = {})
    
  end
  
end
