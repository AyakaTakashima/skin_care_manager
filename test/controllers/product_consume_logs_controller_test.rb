# frozen_string_literal: true

require 'test_helper'

class ProductConsumeLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_consume_log = product_consume_logs(:one)
  end

  test 'should get index' do
    get product_consume_logs_url
    assert_response :success
  end

  test 'should get new' do
    get new_product_consume_log_url
    assert_response :success
  end

  test 'should create product_consume_log' do
    assert_difference('ProductConsumeLog.count') do
      post product_consume_logs_url,
           params: { product_consume_log: { product_id: @product_consume_log.product_id,
                                            use_ended_at: @product_consume_log.use_ended_at,
                                            use_started_at: @product_consume_log.use_started_at } }
    end

    assert_redirected_to product_consume_log_url(ProductConsumeLog.last)
  end

  test 'should show product_consume_log' do
    get product_consume_log_url(@product_consume_log)
    assert_response :success
  end

  test 'should get edit' do
    get edit_product_consume_log_url(@product_consume_log)
    assert_response :success
  end

  test 'should update product_consume_log' do
    patch product_consume_log_url(@product_consume_log),
          params: { product_consume_log: { product_id: @product_consume_log.product_id,
                                           use_ended_at: @product_consume_log.use_ended_at,
                                           use_started_at: @product_consume_log.use_started_at } }
    assert_redirected_to product_consume_log_url(@product_consume_log)
  end

  test 'should destroy product_consume_log' do
    assert_difference('ProductConsumeLog.count', -1) do
      delete product_consume_log_url(@product_consume_log)
    end

    assert_redirected_to product_consume_logs_url
  end
end
