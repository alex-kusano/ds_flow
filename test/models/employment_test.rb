require 'test_helper'

class EmploymentTest < ActiveSupport::TestCase
  
  def setup
    @employmentA = employments(:employment_A)
  end
  
  test "valid employment" do
    assert @employmentA.valid?
  end
  
  test "company must be present" do
    @employmentA.company = nil
    assert_not @employmentA.valid?
  end
  
  test "role must be present" do
    @employmentA.role = nil
    assert_not @employmentA.valid?
  end
  
  test "contact must be present" do
    @employmentA.contact = nil
    assert_not @employmentA.valid?
  end
end
