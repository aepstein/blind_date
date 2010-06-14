module BlindDate
  module ActiveRecord
    module Base
      module ClassMethods
        # Generates an sql fragement representing the sum of a date and a duration
        # == Usage
        #
        # Model.date_add DateTime.now, 10.days
        # => sqlite: DATETIME( '2009-11-25 12:01:01', '+10 DAY' )
        # => mysql: ('2009-11-25 12:01:01' + 10 DAY)
        # => pgsql: (TIMESTAMP '2009-11-25 12:01:01' + '10 DAY')
        # Model.date_add 'models.starts_at', 10.days
        # => sqlite: DATETIME( models.starts_at, '+10 DAY' )
        # Model.date_add :starts_at, :duration, :days
        # => sqlite: DATETIME( "models"."starts_at", '+' || "models"."duration" || ' DAY' )
        # Model.date_add :starts_at, :duration, :days, true
        # => sqlite: DATETIME( "models"."starts_at", '-' || "models"."duration" || ' DAY' )
        #
        # == Options
        # * +date+ - Date subject to calculation, can be date, time, datetime, symbolized column, or string sql fragment
        # * +interval+ - Duration to be added/subtracted, can be duration, number, symbolized column, or string sql fragment
        # * +unit+ - Unit of time for duration, defaults to :seconds, and is ignored if using duration for interval
        # * +diff+ - If true, will subtract duration from date, otherwise will add (default is false)
        def date_add( date, interval, unit = 'SECOND', diff = false)
          if date.is_a? Symbol
            date = "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name(date.to_s)}"
          elsif date.acts_like?(:time) || date.acts_like?(:date)
            date = connection.quote date
          end
          interval = "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name(interval.to_s)}" if interval.is_a? Symbol
          connection.class.date_add date, interval, unit, diff
        end

        # Generates a SQL fragment representing subtraction of a duration from a date
        # Similar to date_add( date, interval, unit, +true+ )
        def date_sub( date, interval, unit = 'SECOND' )
          date_add date, interval, unit, true
        end

      end

      module InstanceMethods
        def date_add( date, interval, unit = 'SECOND', diff = false)
          self.class.date_add( date, interval, unit, diff )
        end
        def date_sub( date, interval, unit = 'SECOND' )
          self.class.date_sub( date, interval, unit )
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods

      end
    end
  end
end

