# frozen_string_literal: true

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:unused_lotion)
  end

  test 'product is valid' do
    assert @product.valid?
  end

  test 'product is invalid if name is null' do
    @product.name = nil
    assert_not @product.valid?
  end

  test 'product is invalid if price is null' do
    @product.price = nil
    assert_not @product.valid?
  end

  test 'product is invalid if user_id is null' do
    @product.user_id = nil
    assert_not @product.valid?
  end
end
