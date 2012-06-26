class Image < Asset
  has_attached_file :asset, :style => IMAGE_STYLES
  validates_attachment  :asset, :presence => true,
                        :content_type => { :content_type => ["image/jpg", "image/png", "image/jpeg"] }
end
