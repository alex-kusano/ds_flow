require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  
  def setup 
    @contactA = contacts(:contact_A)
  end
  
  test "valid contact" do
    assert @contactA.valid?
  end
  
  test "name should be present" do
    @contactA.name = nil
    assert_not @contactA.valid?
  end
  
  test "email should be present" do
    @contactA.email = nil
    assert_not @contactA.valid?
  end
end
