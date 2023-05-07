require "test_helper"

class MonthlyConsumeAmountTest < ActiveSupport::TestCase
  setup do
    @monthly_consume_amount = monthly_consume_amounts(:one)
  end

  test 'monthly_consume_amount is valid' do
    assert @monthly_consume_amount.valid?
  end

  test 'monthly_consume_amount is invalid if month is null' do
    @monthly_consume_amount.month = nil
    assert_not @monthly_consume_amount.valid?
  end

  test 'monthly_consume_amount is invalid if product_id is null' do
    @monthly_consume_amount.product_id = nil
    assert_not @monthly_consume_amount.valid?
  end

  test 'monthly_consume_amount is invalid if product_consume_log_id is null' do
    @monthly_consume_amount.product_consume_log_id = nil
    assert_not @monthly_consume_amount.valid?
  end
end
