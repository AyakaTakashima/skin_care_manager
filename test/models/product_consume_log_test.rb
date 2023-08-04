# frozen_string_literal: true

require 'test_helper'

class ProductConsumeLogTest < ActiveSupport::TestCase
  setup do
    @product_consume_log1 = product_consume_logs(:one)
    @product_consume_log4 = product_consume_logs(:four)
  end

  test '#consume_logs' do
    product = products(:lotion_first_used)
    product_consume_log = ProductConsumeLog.where(product_id: product).where.not(use_ended_at: nil)
    assert_equal product_consume_log, ProductConsumeLog.consume_logs(product)
  end

  test '#calculate_consuming_amount_for_period' do
    amount_per_day = 36
    @product_consume_log1.use_started_at = Date.new(2023, 1, 1)
    @product_consume_log1.use_ended_at = Date.new(2023, 1, 25)
    result = @product_consume_log1.calculate_consuming_amount_for_period(amount_per_day, @product_consume_log1.use_started_at,
                                                                         @product_consume_log1.use_ended_at)
    assert_equal result, 900
  end

  test '#calculate_amount_by_month should create new monthly consume amount record' do
    assert_equal MonthlyConsumeAmount.count, 5
    assert_equal MonthlyConsumeAmount.where(product_consume_log_id: @product_consume_log4.id).last.created_at, Time.current.beginning_of_month.last_month

    consume_dates = Enumerator.produce(@product_consume_log4.use_started_at, &:next_month).take_while { |d| d <= @product_consume_log4.use_ended_at }
    parameter_to_calculate_monthly_amount = {}
    parameter_to_calculate_monthly_amount[:consume_dates] = consume_dates
    parameter_to_calculate_monthly_amount[:product] = Product.find(@product_consume_log4.product_id)
    parameter_to_calculate_monthly_amount[:product_consume_log] = @product_consume_log4
    @product_consume_log4.calculate_amount_by_month(parameter_to_calculate_monthly_amount)

    assert MonthlyConsumeAmount.where(product_consume_log_id: @product_consume_log4.id).last.created_at.today?
    assert_equal MonthlyConsumeAmount.count, 6
  end

  test '#record_monthly_amount should delete old monthly consume amount record and create new monthly consume amount record' do
    assert_equal MonthlyConsumeAmount.count, 5
    assert_equal MonthlyConsumeAmount.where(product_consume_log_id: @product_consume_log1.id).last.created_at, Time.current.beginning_of_month
    @product_consume_log1.record_monthly_amount(@product_consume_log1.use_started_at)
    assert MonthlyConsumeAmount.where(product_consume_log_id: @product_consume_log1.id).last.created_at.today?
    assert_equal MonthlyConsumeAmount.count, 5
  end

  test '#average_period' do
    assert_equal @product_consume_log1.average_period, 0
    assert_equal @product_consume_log4.average_period, 27
  end

  test '#average_amount_per_day' do
    assert_equal @product_consume_log1.average_amount_per_day, 0

    period1 = 1000 / 25
    period2 = 1000 / 30
    average_amount_per_day = (period1 + period2) / 2
    assert_equal @product_consume_log4.average_amount_per_day, average_amount_per_day
  end
end
