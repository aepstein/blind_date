module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module MysqlAdapter

        def date_add_sql( sql, interval, unit, operator )
          "( #{sql} #{operator} INTERVAL #{interval} #{unit} )"
        end

      end
    end
  end
end

ActiveRecord::ConnectionAdapters::MysqlAdapter.send(:include,BlindDate::ActiveRecord::ConnectionAdapters::MysqlAdapter)

