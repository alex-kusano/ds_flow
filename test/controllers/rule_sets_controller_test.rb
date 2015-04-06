require 'test_helper'

class RuleSetsControllerTest < ActionController::TestCase
  setup do
    @rule_set = rule_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rule_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rule_set" do
    assert_difference('RuleSet.count') do
      post :create, rule_set: {  }
    end

    assert_redirected_to rule_set_path(assigns(:rule_set))
  end

  test "should show rule_set" do
    get :show, id: @rule_set
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rule_set
    assert_response :success
  end

  test "should update rule_set" do
    patch :update, id: @rule_set, rule_set: {  }
    assert_redirected_to rule_set_path(assigns(:rule_set))
  end

  test "should destroy rule_set" do
    assert_difference('RuleSet.count', -1) do
      delete :destroy, id: @rule_set
    end

    assert_redirected_to rule_sets_path
  end
end
