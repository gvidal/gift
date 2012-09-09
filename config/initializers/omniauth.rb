Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, '131111200279023', '95cf207bf9ab58916e3aef120aa03337',:scope => 'email,user_birthday,read_stream'
end  