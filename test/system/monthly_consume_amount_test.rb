# frozen_string_literal: true

require 'application_system_test_case'

class MonthlyConsumeAmountsTest < ApplicationSystemTestCase
  setup do
    @heavy_user = users(:heavy_user)
  end

  test 'cannot visit the index if no sign in' do
    visit monthly_consume_amount_url
    assert_current_path new_user_session_path
  end

  test 'visiting the index' do
    sign_in @heavy_user
    visit monthly_consume_amount_url
    assert_current_path monthly_consume_amount_path
  end

  test 'visiting the show' do
    sign_in @heavy_user
    visit monthly_consume_amount_url
    first('#show_monthly_logs').click
    date = Time.zone.today.beginning_of_month
    assert_text "#{date.year}年#{date.month}月の消費予定金額は"
  end
end
