require 'blind_date/active_record/base'
require 'blind_date/active_record/connection_adapters/abstract_adapter'

ActiveRecord::Base.extend BlindDate::ActiveRecord::Base
ActiveRecord::ConnectionAdapters::AbstractAdapter.extend BlindDate::ActiveRecord::ConnectionAdapters::AbstractAdapter

