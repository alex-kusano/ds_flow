require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  
  def setup 
    @roleA = roles(:role_A)
  end
  
  test "valid role" do
    assert @roleA.valid?
  end
  
  test "name should be present" do
    @roleA.name = nil
    assert_not @roleA.valid?
  end
end
