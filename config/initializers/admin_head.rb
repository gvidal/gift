require 'ostruct'
ADMIN_TABS = [OpenStruct.new(:tab => {:controller => "admin/admin_users", :action => "index"},
                                      :subtabs => [{:controller => "admin/admin_users", :action => "index"}]),
              OpenStruct.new(:tab => {:controller => "admin/option_types", :action => "index"},
                             :subtabs => [{:controller => "admin/option_types", :action => "index"},
                                          {:controller => "admin/option_values", :action => "index"},
                                          {:controller => "admin/products", :action => "index"}])
              ]
              
IMAGE_STYLES = { :medium => "300x300", :thumb => "100x100" }

TOKEN_INPUT_LIMIT = 8