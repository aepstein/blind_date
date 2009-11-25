module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module SQLiteAdapter

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
    end
  end
end

ActiveRecord::ConnectionAdapters::SQLiteAdapter.extend BlindDate::ActiveRecord::ConnectionAdapters::SQLiteAdapter

