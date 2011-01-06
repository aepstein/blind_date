module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module PostgresqlAdapter
        module ClassMethods
          def date_add_sql( style, sql, interval, unit, operator )
            case interval
            when Numeric
              "( #{sql} #{operator} '#{interval} #{unit}' )"
            when String
              "( #{sql} #{operator} #{interval} || ' #{unit}')"
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

ActiveRecord::ConnectionAdapters::PostgresqlAdapter.send :include, BlindDate::ActiveRecord::ConnectionAdapters::PostgresqlAdapter

