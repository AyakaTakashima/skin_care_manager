# frozen_string_literal: true

class ProductConsumeLogs::UseEndController < ApplicationController
  before_action :set_product

  def index
    @product_consume_log = @product.product_consume_logs.last
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
end
