module BlindDate
  module ActiveRecord
    module ConnectionAdapters

      # Includes extended behaviors
      # Each DBMS-specific module must implement the private methods or raise NotImplemented
      # for each private method
      module AbstractAdapter

        # Performs arithmetic on string is an SQL-escaped date/time/datetime or returns a date/time/datetime
        def date_add(date, interval)
          date = quote(date) if date.acts_like?(:time) || date.acts_like?(:date)
          if interval.is_a? ActiveSupport::Duration
            return interval.parts.inject( date ) do |memo, span|
              date_add_sql_without_operator( memo, span.last, span.first.to_s.singularize.upcase )
            end
          end
          return date_add_sql_without_operator( date, interval, 'SECOND' ) if interval.is_a? Numeric
          raise ArgumentError
        end

        private

        # Adds appropriate operator before calling adapter-specific method
        def date_add_sql_without_operator( sql, interval, unit )
          date_add_sql sql, interval, unit, ( interval < 0 ? '-' : '+' )
        end

        # Will attempt to load the correct behavior if this is not already provided
        def date_add_sql( sql, interval, unit, operator )
          require "blind_date/active_record/connection_adapters/#{adapter_name.downcase}_adapter.rb"
          date_add_sql( sql, interval, unit, operator )
        end

      end
    end
  end
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, BlindDate::ActiveRecord::ConnectionAdapters::AbstractAdapter)

