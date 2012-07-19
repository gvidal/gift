require 'ostruct'
#ADMIN_TABS = [OpenStruct.new(:tab => {:controller => "admin/admin_users", :action => "index"},
#                                      :subtabs => [{:controller => "admin/admin_users", :action => "index"}]),
#              OpenStruct.new(:tab => {:controller => "admin/option_types", :action => "index"},
#                             :subtabs => [{:controller => "admin/option_types", :action => "index"},
#                                          {:controller => "admin/option_values", :action => "index"},
#                                          {:controller => "admin/products", :action => "index"}])
#              ]

#admin_tabs_aux = TabStructure::TabList.new("admin/shared/tabs")
#admin_tab_scope = ['admin','tabs','main_tabs']
#admin_tabs_aux.add_tab(I18n.t('admin_users',:scope => admin_tab_scope), {controller: "admin/admin_users"}) do |tab_info|
#  tab_info.highlights_on(controller: "admin/admin_users")
#end
#admin_tabs_aux.add_tab(I18n.t('products',:scope => admin_tab_scope),{controller: "admin/products"}) do |tab_info|
#  tab_info.highlights_on(controller: "admin/products")
#  tab_info.highlights_on(controller: "admin/option_values")
#  tab_info.highlights_on(controller: "admin/option_types")
#  tab_info.highlights_on(controller: "admin/variants")
#end
#
#ADMIN_TABS = admin_tabs_aux
#
#admin_subtabs_aux =  TabStructure::TabList.new("admin/shared/subtabs")
#admin_subtabs_scope = ['admin','subtabs','main_tabs']
#admin_users_subtabs =  %w(admin/admin_users)
#admin_subtabs_aux.add_tab(I18n.t('admin_users',:scope => admin_subtabs_scope),{controller: "admin/admin_users"}) do |tab_info|
#  admin_users_subtabs.each do |controller|
#    tab_info.shows_on(controller: controller)
#  end
#  tab_info.highlights_on(controller: "admin/admin_users")
#end
#product_subtabs = %w(admin/products admin/option_values admin/option_types admin/variants)
#admin_subtabs_aux.add_tab(I18n.t('products',:scope => admin_subtabs_scope),{controller: "admin/products"}) do |tab_info|
#  product_subtabs.each do |controller|
#    tab_info.shows_on(controller: controller)
#  end
#  tab_info.highlights_on(controller: "admin/products")
#end
#
#admin_subtabs_aux.add_tab(I18n.t('variants',:scope => admin_subtabs_scope),{controller: "admin/variants"}) do |tab_info|
#  product_subtabs.each do |controller|
#    tab_info.shows_on(controller: controller)
#  end
#  tab_info.highlights_on(controller: "admin/variants")
#end
#
#admin_subtabs_aux.add_tab(I18n.t('option_types',:scope => admin_subtabs_scope),{controller: "admin/option_types"}) do |tab_info|
#  product_subtabs.each do |controller|
#    tab_info.shows_on(controller: controller)
#  end
#  tab_info.highlights_on(controller: "admin/option_types")
#end
#
#admin_subtabs_aux.add_tab(I18n.t('option_values',:scope => admin_subtabs_scope),{controller: "admin/option_values"}) do |tab_info|
#  product_subtabs.each do |controller|
#    tab_info.shows_on(controller: controller)
#  end
#  tab_info.highlights_on(controller: "admin/option_values")
#end
#
#ADMIN_SUBTABS = admin_subtabs_aux
              
IMAGE_STYLES = { :medium => "300x300", :thumb => "60x60", :public_lateral => "100x75", :featured => "240x90"}

TOKEN_INPUT_LIMIT = 8