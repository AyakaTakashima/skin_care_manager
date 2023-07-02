# frozen_string_literal: true

require 'test_helper'

class MonthlyConsumeAmountTest < ActiveSupport::TestCase
  setup do
    heavy_user = users(:heavy_user)
    @monthly_consume_amounts = MonthlyConsumeAmount.includes(product: :user).where(user: { id: heavy_user.id })
  end

  test '#calculate_average_amount_by_month' do
    assert_equal @monthly_consume_amounts.calculate_average_amount_by_month, 1666
  end

  test '#get_number_of_consumed_products' do
    date = Time.zone.today.beginning_of_month - 1.month
    assert_equal @monthly_consume_amounts.get_number_of_consumed_products(date), 2
  end

  test '#calculate_monthly_consume_amounts' do
    date = Time.zone.today.beginning_of_month - 1.month
    assert_equal @monthly_consume_amounts.calculate_monthly_consume_amounts(date), 3000
  end
end
