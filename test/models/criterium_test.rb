require 'test_helper'

class CriteriumTest < ActiveSupport::TestCase
  
  def setup 
    @criteriumA = criteria(:criterium_A)
  end
  
  test "valid criterium" do
    assert @criteriumA.valid?
  end
  
  test "rule must be present" do
    @criteriumA.rule = nil
    assert_not @criteriumA.valid?
  end
  
  test "role must be present" do
    @criteriumA.role = nil
    assert_not @criteriumA.valid?
  end
  
  test "count must be present" do
    @criteriumA.count = nil
    assert_not @criteriumA.valid?
  end
  
  test "count must be positive" do
    @criteriumA.count = -2
    assert_not @criteriumA.valid?
  end
end
