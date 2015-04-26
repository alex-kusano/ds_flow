require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  
  def setup
    @string_category = categories(:string_cat)
  end
  
  test "valid object" do
    assert @string_category.valid?
  end
  
  test "tab_name should be present" do
    @string_category.tab_name = ""
    assert_not @string_category.valid?
  end
  
  test "tab_value should be present unless datatype is 'NIL'" do
    @string_category.tab_value = ""
    assert_not @string_category.valid?
    @string_category.datatype = Category.NIL
    assert @string_category.valid?
  end
  
  test "datatype should be present" do
    @string_category.datatype = nil
    assert_not @string_category.valid?
  end
  
  test "datatype should be valid" do
    @string_category.datatype = 100
    assert_not @string_category.valid?
  end
  
  test "operation should be present" do
    @string_category.operation = nil
    assert_not @string_category.valid?
  end
  
  test "operation should be valid" do
    @string_category.operation = 100
    assert_not @string_category.valid?
  end
  
  test "category should be present" do
    @string_category.company = nil
    assert_not @string_category.valid?
  end
  
  test "must match parent" do
    child_category = categories(:child_cat)
    assert child_category.valid?
    child_category.company = companies(:company_B)
    assert_not child_category.valid?
  end
  
  
end
