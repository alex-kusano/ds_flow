require 'test_helper'

class ConnectConfigTest < ActiveSupport::TestCase
  def setup
    @configA = connect_configs(:configA)
  end
  
  test "valid connect configuration" do
    assert @configA.valid?
  end
  
  test "send interface must be present" do
    @configA.send_interface_id = nil
    assert_not @configA.valid?
  end
  
  test "sign interface must be present" do
    @configA.sign_interface_id = nil
    assert_not @configA.valid?
  end
  
  test "account id must be present" do
    @configA.account_id = nil
    assert_not @configA.valid?
  end
end
