require 'ostruct'
ADMIN_TABS = [OpenStruct.new(:tab => {:controller => "admin/admin_users", :action => "index"},
                                      :subtabs => [{:controller => "admin/admin_users", :action => "index"}])
#              OpenStruct.new(:tab => :products, :products => [:products, :variants])  
              ]
              
IMAGE_STYLES = { :medium => "300x300", :thumb => "100x100" }