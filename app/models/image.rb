class Image < Asset
  has_attached_file :asset, :style => {
                                        medium: "300x300#", 
                                        thumb: "60x60#", 
                                        public_lateral: "100x75#", 
                                        featured: "240x90#",
                                        carousel: "240x125#"
                                      }
  validates_attachment  :asset, :presence => true,
                        :content_type => { :content_type => ["image/jpg", "image/png", "image/jpeg"] }
end
