module BlindDate
  module ActiveRecord
    module Base

      def date_add( date, interval )
        date = "#{connection.quote_table_name(self.class.table_name)}.#{connection.quote_column_name(date.to_s)}" if date.is_a? Symbol
        connection.date_add( date, interval )
      end

    end
  end
end

