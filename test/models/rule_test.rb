require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  
  def setup 
    @ruleA = rules(:rule_A)
  end
  
  test "valid rule" do
    assert @ruleA.valid?
  end
  
  test "rule_set must be present" do
    @ruleA.rule_set = nil
    assert_not @ruleA.valid?
  end
end
