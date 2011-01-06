module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module Mysql2Adapter
        module ClassMethods
          def date_add_sql( style, sql, interval, unit, operator )
            "( #{sql} #{operator} INTERVAL #{interval} #{unit} )"
          end
        end

        module InstanceMethods

        end

        def self.included(receiver)
          receiver.extend         ClassMethods
          receiver.send :include, InstanceMethods
        end
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::Mysql2Adapter.send :include, BlindDate::ActiveRecord::ConnectionAdapters::Mysql2Adapter

