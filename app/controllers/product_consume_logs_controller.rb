# frozen_string_literal: true

class ProductConsumeLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product_consume_log, only: %i[edit update destroy]
  before_action :set_product, only: %i[new use_end edit update]

  def new
    @product_consume_log = ProductConsumeLog.new
  end

  def use_end
    @product_consume_log = @product.product_consume_logs.last
  end

  def edit; end

  def create
    @product_consume_log = ProductConsumeLog.new(product_consume_log_params)
    @product = Product.find(params[:product_id])

    if @product_consume_log.save
      scheduled_consume_date = @product_consume_log.use_started_at + Product.find(@product_consume_log.product_id).average_period.day
      @product_consume_log.record_monthly_amount(scheduled_consume_date)
      redirect_to root_url, notice: "#{t('activerecord.models.product_consume_log')}#{t('notice.create')}"
    else
      render :new, layout: false, status: :unprocessable_entity
    end
  end

  def update
    if @product_consume_log.update(product_consume_log_params)
      product_id = @product_consume_log.product_id
      average_period = @product_consume_log.average_period
      average_amount_per_day = @product_consume_log.average_amount_per_day
      Product.find(product_id).update(average_period:, average_amount_per_day:)

      if @product_consume_log.use_ended_at.nil?
        scheduled_consume_date = @product_consume_log.use_started_at + Product.find(product_id).average_period.day
        @product_consume_log.record_monthly_amount(scheduled_consume_date)
      else
        @product_consume_log.record_monthly_amount(@product_consume_log.use_ended_at)
      end

      case params[:product_consume_log][:view]
      when 'edit_in_product_show'
        redirect_to product_url(product_id)
      else
        redirect_to root_url, notice: "#{t('activerecord.models.product_consume_log')}#{t('notice.create')}"
      end
    else
      render_error_view
    end
  end

  def destroy
    product_id = @product_consume_log.product_id
    product = Product.find(product_id)

    @product_consume_log.destroy
    redirect_to product, notice: "#{t('activerecord.models.product_consume_log')}#{t('notice.destroy')}"

    average_period = @product_consume_log.average_period
    average_amount_per_day = @product_consume_log.average_amount_per_day
    Product.find(product_id).update(average_period:, average_amount_per_day:)
  end

  private

  def set_product_consume_log
    @product_consume_log = ProductConsumeLog.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def product_consume_log_params
    params.require(:product_consume_log).permit(:product_id, :use_started_at, :use_ended_at)
  end

  def render_error_view
    case params[:product_consume_log][:view]
    when 'use_end_index'
      render template: 'product_consume_logs/use_end/index', layout: false, status: :unprocessable_entity
    else
      render :edit, layout: false, status: :unprocessable_entity
    end
  end
end
