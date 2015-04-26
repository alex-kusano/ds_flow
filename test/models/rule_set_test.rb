require 'test_helper'

class RuleSetTest < ActiveSupport::TestCase
  
  def setup
    @rulesetA = rule_sets(:ruleset_A)
  end
  
  test "valid rule set" do
    assert @rulesetA.valid?
  end
  
  test "code must be present" do
    @rulesetA.code = nil
    assert_not @rulesetA.valid?
  end
end
