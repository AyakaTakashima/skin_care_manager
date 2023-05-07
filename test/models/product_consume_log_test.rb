require "test_helper"

class ProductConsumeLogTest < ActiveSupport::TestCase
  setup do
    @product_consume_log = product_consume_logs(:one)
  end

  test 'product_consume_log is valid' do
    assert @product_consume_log.valid?
  end

  test 'product_consume_log is invalid if use_started_at is null' do
    @product_consume_log.use_started_at = nil
    assert_not @product_consume_log.valid?
  end

  test 'product_consume_log is invalid if product_id is null' do
    @product_consume_log.product_id = nil
    assert_not @product_consume_log.valid?
  end
end
