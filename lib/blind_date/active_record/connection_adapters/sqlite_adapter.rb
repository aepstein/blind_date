module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module SQLiteAdapter
        module ClassMethods
          def date_add_sql( style, sql, interval, unit, operator )
            date_function = case style
              when :date then 'DATE'
              when :datetime then 'DATETIME'
              when :time then 'TIME'
            end
            case interval
              when Numeric
                "#{date_function}( #{sql}, '#{operator}#{interval} #{unit}' )"
              when String
                "#{date_function}( #{sql}, '#{operator}' || #{interval} || ' #{unit}' )"
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

