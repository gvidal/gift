module ApplicationHelper
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
end
