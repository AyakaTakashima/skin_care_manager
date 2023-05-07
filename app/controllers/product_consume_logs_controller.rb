class ProductConsumeLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product_consume_log, only: %i[ edit update destroy ]
  before_action :set_product, only: %i[ new use_end edit update ]

  def new
    @product_consume_log = ProductConsumeLog.new
  end

  def use_end
    @product_consume_log = @product.product_consume_logs.last
  end

  def edit; end

  def create
    @product_consume_log = ProductConsumeLog.new(product_consume_log_params)

    respond_to do |format|
      if @product_consume_log.save
        scheduled_consume_date = @product_consume_log.use_started_at + Product.find(@product_consume_log.product_id).average_period.day
        @product_consume_log.record_monthly_amount(scheduled_consume_date, @product_consume_log)
        format.html { redirect_to root_url, notice: "#{t('activerecord.models.product_consume_log')}#{t('notice.create')}" }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product_consume_log.update(product_consume_log_params)
        format.html { redirect_to request.referer, notice: "#{t('activerecord.models.product_consume_log')}#{t('notice.create')}" }

        product_id = @product_consume_log.product_id
        average_period = calculate_average_period(product_id)
        average_amount_per_day = calculate_average_amount_per_day(product_id)
        Product.find(product_id).update(average_period: average_period, average_amount_per_day: average_amount_per_day)

        if @product_consume_log.use_ended_at.nil?
          scheduled_consume_date = @product_consume_log.use_started_at + Product.find(product_id).average_period.day
          @product_consume_log.record_monthly_amount(scheduled_consume_date, @product_consume_log)
        elsif
          @product_consume_log.record_monthly_amount(@product_consume_log.use_ended_at, @product_consume_log)
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    product_id = @product_consume_log.product_id
    product = Product.find(product_id)

    @product_consume_log.destroy
    respond_to do |format|
      format.html { redirect_to product, notice: "#{t('activerecord.models.product_consume_log')}#{t('notice.destroy')}" }

      average_period = calculate_average_period(product_id)
      average_amount_per_day = calculate_average_amount_per_day(product_id)
      Product.find(product_id).update(average_period: average_period, average_amount_per_day: average_amount_per_day)
    end
  end

  private

  def calculate_average_period(product_id)
    logs = ProductConsumeLog.where('product_id=?', product_id).where.not(use_ended_at:nil)
    if logs.empty?
      0
    else
      number_of_periods = logs.count
      total_period = 0
  
      logs.each do |log|
        period = log.use_ended_at - log.use_started_at + 1 #X日間という数え方をしたいので1を足している
        total_period += period.numerator
      end
      total_period / number_of_periods
    end
  end

  def calculate_average_amount_per_day(product_id)
    logs = ProductConsumeLog.where('product_id=?', product_id).where.not(use_ended_at:nil)
    product = Product.find(product_id)
    if logs.empty?
      0
    else
      number_of_logs = logs.count
      total_amount_per_day = 0
  
      logs.each do |log|
        period = log.use_ended_at - log.use_started_at + 1 #X日間という数え方をしたいので1を足している
        total_amount_per_day += (product.price / period.numerator)
      end
      total_amount_per_day / number_of_logs
    end
  end

  def set_product_consume_log
    @product_consume_log = ProductConsumeLog.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def product_consume_log_params
    params.require(:product_consume_log).permit(:product_id, :use_started_at, :use_ended_at)
  end
end
