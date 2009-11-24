require 'rubygems'
require 'activerecord'

ENV['TZ'] = 'UTC'
Time.zone = 'Eastern Time (US & Canada)'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Base.configurations = true

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :activities do |t|
    t.datetime :starts_at
    t.integer :duration
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'blind_date'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.before(:each) do
    class Activity < ActiveRecord::Base
    end

    Activity.destroy_all
  end

  config.after(:each) do
    Object.send(:remove_const, :Activity)
  end
end

