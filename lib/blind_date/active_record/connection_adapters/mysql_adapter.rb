module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module MysqlAdapter
        module ClassMethods
          def date_add_sql( sql, interval, unit, operator )
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

ActiveRecord::ConnectionAdapters::MysqlAdapter.send :include, BlindDate::ActiveRecord::ConnectionAdapters::MysqlAdapter

