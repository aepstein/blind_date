require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "BlindDate" do
  before(:each) do
    @activity = Activity.create( :starts_at => DateTime.now, :duration => 60 )
    @future = Activity.create( :starts_at => @activity.starts_at + 60.seconds )
  end

  it "should produce valid date_add output" do
    matches = matches_for @activity.date_add( @activity.starts_at, 60.seconds )
    matches.size.should eql 1
    matches.should include @future
  end

  it "should produce valid date_add output with plain sql string" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@future.starts_at)} = " +
      @activity.date_add('activities.starts_at', 60.seconds) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should produce valid date_add output with multipart date" do
    other_activity = Activity.create( :starts_at => @activity.starts_at + 2.months + 10.seconds )
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(other_activity.starts_at)} = " +
      @activity.date_add('activities.starts_at', 2.months + 10.seconds ) ])
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should produce valid date_add output with a symbol string" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@future.starts_at)} = " +
      @activity.date_add( :starts_at, 60.seconds ) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  it "should default to seconds with an integer interval" do
    matches = Activity.find( :all, :conditions => [ "#{@activity.connection.quote(@future.starts_at)} = " +
      @activity.date_add( 'activities.starts_at', 60 ) ] )
    matches.size.should eql 1
    matches.should include @activity
  end

  def matches_for(condition)
    Activity.find( :all, :conditions => "starts_at = #{condition}" )
  end
end

