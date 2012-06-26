require 'active_record_extensions/time_parser'
require 'active_record_extensions/token_input'
require 'active_record_extensions/media_attachment'
ActiveRecord::Base.send(:include, ActiveRecordExtensions::TimeParser)
ActiveRecord::Base.send(:include, ActiveRecordExtensions::TokenInput)
ActiveRecord::Base.send(:include, ActiveRecordExtensions::MediaAttachment)
      

