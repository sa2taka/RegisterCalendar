require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = Event.new(date: "2017/11/12", start: "12:05", end: "17:05")
  end

  test "date should be present" do
    @event.date = ""
    assert_not @event.valid?
  end
end
