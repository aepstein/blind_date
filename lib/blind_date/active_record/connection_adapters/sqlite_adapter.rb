module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module SQLiteAdapter

        def date_add_sql( sql, interval, unit, operator )
          "DATETIME( #{sql}, '#{operator}#{interval.abs} #{unit}' )"
        end

      end
    end
  end
end

ActiveRecord::ConnectionAdapters::SQLiteAdapter.send(:include, BlindDate::ActiveRecord::ConnectionAdapters::SQLiteAdapter)

