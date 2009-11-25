module BlindDate
  module ActiveRecord
    module Base

      def date_add( date, interval, unit = 'SECOND', diff = false)
        date = "#{connection.quote_table_name(self.class.table_name)}.#{connection.quote_column_name(date.to_s)}" if date.is_a? Symbol
        interval = "#{connection.quote_table_name(self.class.table_name)}.#{connection.quote_column_name(interval.to_s)}" if interval.is_a? Symbol
        connection.date_add date, interval, unit, diff
      end

      def date_sub( date, interval, unit = 'SECOND' )
        date_add( date, interval, unit, true )
      end

    end
  end
end

