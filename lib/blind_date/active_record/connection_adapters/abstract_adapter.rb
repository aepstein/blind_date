module BlindDate
  module ActiveRecord
    module ConnectionAdapters
      module AbstractAdapter
        module ClassMethods

          # Performs arithmetic on string is an SQL-escaped date/time/datetime or returns a date/time/datetime
          def date_add( style, date, interval, unit = 'SECOND', diff = false )
            case interval
            when ActiveSupport::Duration
              interval.parts.inject( date ) do |memo, span|
                date_add_sql_without_operator style, memo, span.last, span.first.to_s.singularize.upcase, diff
              end
            when String
              date_add_sql style, date, interval, unit.to_s.singularize.upcase, ( diff ? '-' : '+' )
            when Numeric
              date_add_sql_without_operator style, date, interval, unit.to_s.singularize.upcase, diff
            else
              raise ArgumentError
            end
          end

          # Returns name of adapter suitable for loading related classes
          # Should have same output as instance method of same name
          # TODO: Kludgy: maybe upstream could provide a class method?
          def adapter_name
            to_s.underscore[ /\/([^\/]+)_adapter$/, 1 ].gsub( '_', '' )
          end

          private

          # Adds appropriate operator before calling adapter-specific method
          def date_add_sql_without_operator( style, sql, interval, unit, diff )
            if diff
              date_add_sql style, sql, interval.abs, unit, ( interval < 0 ? '+' : '-' )
            else
              date_add_sql style, sql, interval.abs, unit, ( interval < 0 ? '-' : '+' )
            end
          end

          # Will attempt to load the correct behavior if this is not already provided
          def date_add_sql( style, sql, interval, unit, operator )
            require "blind_date/active_record/connection_adapters/#{adapter_name}_adapter"
            date_add_sql( style, sql, interval, unit, operator )
          end

        end

        module InstanceMethods
          def date_add_sql( style, sql, interval, unit, operator )
            self.class.date_add_sql( style, sql, interval, unit, operator )
          end
        end

        def self.included(receiver)
          receiver.extend         ClassMethods
          receiver.send :include, InstanceMethods
        end
      end
    end
  end
end

