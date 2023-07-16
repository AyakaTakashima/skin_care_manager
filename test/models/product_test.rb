# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @product1 = products(:unused_lotion)
    @product2 = products(:measuring_lotion)
    @product3 = products(:lotion_first_used)
    @product4 = products(:lotion_third_using)
  end

  test '#in_use?' do
    assert_not Product.in_use?(@product1.id)
    assert Product.in_use?(@product2.id)
    assert_not Product.in_use?(@product3.id)
    assert Product.in_use?(@product4.id)
  end

  test '#scheduled_consume_date' do
    use_started_at = Time.current.beginning_of_month - 6.days
    period1 = 30
    period2 = 25
    average_period = (period1 + period2) / 2
    scheduled_consume_date = use_started_at + average_period.day
    assert_equal @product4.scheduled_consume_date, scheduled_consume_date
  end

  test '#format_scheduled_consume_date' do
    use_started_at = Time.current.beginning_of_month - 6.days
    period1 = 30
    period2 = 25
    average_period = (period1 + period2) / 2
    scheduled_consume_date = use_started_at + average_period.day
    wday = %w[日 月 火 水 木 金 土]
    formatted_scheduled_consume_date = scheduled_consume_date.strftime("%m/%d(#{wday[scheduled_consume_date.wday]})")
    assert_equal @product4.format_scheduled_consume_date, formatted_scheduled_consume_date
  end

  test '#count_until_scheduled_consume_date' do
    today = Time.zone.today
    use_started_at = Date.current.beginning_of_month - 6.days
    period1 = 30
    period2 = 25
    average_period = (period1 + period2) / 2
    scheduled_consume_date = use_started_at + average_period.day
    result = scheduled_consume_date - today
    assert_equal @product4.count_until_scheduled_consume_date, result
  end

  test '#get_number_of_consume_logs' do
    last_month = Time.zone.today.beginning_of_month - 1.month
    assert_equal @product4.get_number_of_consume_logs(last_month), 2
  end

  test '#calculate_monthly_consume_amounts' do
    last_month = Time.zone.today.beginning_of_month - 1.month
    assert_equal @product4.calculate_monthly_consume_amounts(last_month), 2000
  end
end
