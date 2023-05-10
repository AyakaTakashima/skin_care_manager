# frozen_string_literal: true

require 'test_helper'

class MonthlyConsumeAmountControllerTest < ActionDispatch::IntegrationTest
  setup do
    @heavy_user = users(:heavy_user)
    sign_in @heavy_user
  end

  test 'should get index' do
    get monthly_consume_amount_url
    assert_response :success
  end

  test 'should get show' do
    get monthly_log_url(year: Time.zone.today.year, month: Time.zone.today.month)
    assert_response :success
  end
end
