require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BlindDate" do
  before(:each) do
    @activity = Activity.create( :starts_at => DateTime.now, :duration => 60 )
    @future = Activity.create( :starts_at => @activity.starts_at + 60.seconds, :duration => 60 )
  end

  it "should produce valid date_add output" do
    matches = matches_for Activity.date_add( @activity.starts_at, 60.seconds )
    matches.size.should eql 1
    matches.should include @future
  end

  it "should produce valid date_add output with plain sql string" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@future.starts_at)} = " +
      Activity.date_add( 'activities.starts_at', 60.seconds ) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should produce valid date_add output with multipart date" do
    other_activity = Activity.create( :starts_at => @activity.starts_at + 2.months + 10.seconds )
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(other_activity.starts_at)} = " +
      Activity.date_add( :starts_at, 2.months + 10.seconds ) ])
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should produce valid date_add output with a symbol string" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@future.starts_at)} = " +
      Activity.date_add( :starts_at, 60.seconds ) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should default to seconds with an integer interval" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@future.starts_at)} = " +
      Activity.date_add( :starts_at, 60 ) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should accept sql fragment, unit, operator for interval" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@activity.starts_at + @activity.duration.seconds)} = " +
      Activity.date_add( :starts_at, 'activities.duration' ) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should accept a symbol for the interval" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@activity.starts_at + @activity.duration.seconds)} = " +
      Activity.date_add( :starts_at, :duration ) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should accept an alternative unit for a specified interval" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@activity.starts_at + @activity.duration.seconds)} = " +
      Activity.date_add( :starts_at, 1, :minutes ) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should calculate a difference with the sub method" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote @activity.starts_at} = " +
      Activity.date_sub( 'activities.starts_at', 1, :minutes ) ] )
    matches.size.should eql 1
    matches.should include @future
  end

  def matches_for(condition)
    Activity.find( :all, :conditions => "starts_at = #{condition}" )
  end
end

