require 'active_record_extensions/time_parser'
ActiveRecord::Base.send(:include, ActiveRecordExtensions::TimeParser)