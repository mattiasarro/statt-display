require File.dirname(__FILE__) + "/../minitest_helper"

class TimeframeTest < MiniTest::Rails::ActiveSupport::TestCase

  it "should work with nil" do
    tf = Timeframe.new(nil)
    tf.duration.must_equal 60.minutes
  end
  
end
