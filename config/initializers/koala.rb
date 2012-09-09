module Facebook
 CONFIG = YAML.load_file(File.join(Rails.root ,"config","facebook.yml"))[Rails.env]
 APP_ID = CONFIG['app_id']
 SECRET = CONFIG['secret_key']
 CALLBACK_URL = CONFIG['callback_url']
 TEST = Koala::Facebook::TestUsers.new(:app_id => APP_ID, :secret => SECRET)
 def self.test_users_are_friends!
   list = TEST.list
   list.each_with_index do |fb_user, index|
     list.map{|other_fb_user| TEST.befriend(other_fb_user, fb_user) rescue nil}
   end
 end
 
 def self.set_passwords!(password = "testpassword")
   TEST.list.each do |user|
     TEST.update(user, {:password => password})
   end
 end
end
Koala::Facebook::OAuth.class_eval do
 def initialize_with_default_settings(*args)
   case args.size
   when 0, 1
   raise "application id and/or secret are not specified in the config" unless Facebook::APP_ID && Facebook::SECRET
   initialize_without_default_settings(Facebook::APP_ID.to_s, Facebook::SECRET.to_s, Facebook::CALLBACK_URL.to_s)
   when 2, 3
   initialize_without_default_settings(*args)
   end
 end
 
 alias_method_chain :initialize, :default_settings
end
