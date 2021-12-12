require "test_helper"

class ReceiptControllerTest < ActionDispatch::IntegrationTest
  test "should get calendar" do
    get receipt_calendar_url
    assert_response :success
  end

  test "should get new" do
    get receipt_new_url
    assert_response :success
  end

  test "should get edit" do
    get receipt_edit_url
    assert_response :success
  end

  test "should get list" do
    get receipt_list_url
    assert_response :success
  end
end
