require 'test_helper'

class ReceiptControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'should get calendar' do
    sign_in users(:test)

    get receipt_calendar_url
    assert_response :success
  end

  test 'should upload file' do
    sign_in users(:test)
    post receipt_import_url, params: { file: fixture_file_upload('receipts.csv', 'text/csv') }

    assert_response :redirect
  end

  test 'should get list' do
    sign_in users(:test)

    get receipt_list_url
    assert_response :success
  end

  test 'should get exported file' do
    sign_in users(:test)
    get receipt_export_path

    assert_response :success
  end
end
