require 'active_record_extensions/time_parser'
require 'active_record_extensions/token_input'
ActiveRecord::Base.send(:include, ActiveRecordExtensions::TimeParser)
ActiveRecord::Base.send(:include, ActiveRecordExtensions::TokenInput)
      

