require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  
  def setup 
    @company = companies(:company_B)
  end
  
  test "valid company" do
    assert @company.valid?
  end
  
  test "name must be present" do
    @company.name = nil
    assert_not @company.valid?
  end
  
end
