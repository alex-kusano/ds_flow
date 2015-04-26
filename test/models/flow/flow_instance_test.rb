require 'test_helper'

class Flow::FlowInstanceTest < ActiveSupport::TestCase

  def setup
    @instance = flow_flow_instances(:instance_A)
  end
  
  test "valid instance" do
    assert @instance.valid?
  end
  
  test "envelope id must be present" do
    @instance.envelope_id = nil
    assert_not @instance.valid?
  end
  
  test "code must be present" do
    @instance.code = nil
    assert_not @instance.valid?
  end
  
  test "routing order must be present" do
    @instance.routing_order = nil
    assert_not @instance.valid?
  end
  
  test "company must be present" do
    @instance.company = nil
    assert_not @instance.valid?
  end
  
end
