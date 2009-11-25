module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module PostgresqlAdapter

        def date_add_sql( sql, interval, unit, operator )
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
    end
  end
end

ActiveRecord::ConnectionAdapters::MysqlAdapter.send :include, BlindDate::ActiveRecord::ConnectionAdapters::MysqlAdapter

