module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module SQLiteAdapter
        module ClassMethods
          def date_add_sql( sql, interval, unit, operator )
            case interval
            when Numeric
              "DATETIME( #{sql}, '#{operator}#{interval} #{unit}' )"
            when String
              "DATETIME( #{sql}, '#{operator}' || #{interval} || ' #{unit}' )"
            else
              raise ArgumentError
            end
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

ActiveRecord::ConnectionAdapters::SQLiteAdapter.send :include, BlindDate::ActiveRecord::ConnectionAdapters::SQLiteAdapter

