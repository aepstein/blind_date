require 'blind_date/active_record/base'
require 'blind_date/active_record/connection_adapters/abstract_adapter'

ActiveRecord::Base.send(:include, BlindDate::ActiveRecord::Base)
ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, BlindDate::ActiveRecord::ConnectionAdapters::AbstractAdapter)

