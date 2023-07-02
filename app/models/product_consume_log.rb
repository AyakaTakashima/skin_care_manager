# frozen_string_literal: true

class ProductConsumeLog < ApplicationRecord
  belongs_to :product
  has_many :monthly_consume_amounts, dependent: :destroy

  validates :use_started_at, presence: true

  def calculate_consuming_amount_for_period(amount_per_day, first_day, last_day)
    period = (last_day - first_day).numerator + 1 # X日間という数え方をしたいので1を足している
    period * amount_per_day
  end

  def calculate_amount_by_month(parameter_to_calculate_monthly_amount)
    product = parameter_to_calculate_monthly_amount[:product]
    product_consume_log = parameter_to_calculate_monthly_amount[:product_consume_log]
    use_started_at = product_consume_log.use_started_at
    amount_per_day = product.price / ((use_ended_at - use_started_at).numerator + 1) # X日間という数え方をしたいので1を足している

    last_index = parameter_to_calculate_monthly_amount[:consume_dates].count - 1
    parameter_to_calculate_monthly_amount[:consume_dates].each_with_index do |consume_date, index|
      if index.zero?
        consuming_amount = calculate_consuming_amount_for_period(amount_per_day, use_started_at, use_started_at.end_of_month)
      elsif index == last_index
        total_amount_until_last_month = MonthlyConsumeAmount.where(product_consume_log_id: product_consume_log.id).sum(:amount)
        consuming_amount = product.price - total_amount_until_last_month
      else
        consuming_amount = calculate_consuming_amount_for_period(amount_per_day, consume_date.beginning_of_month, consume_date.end_of_month)
      end
      MonthlyConsumeAmount.create(product_id: product.id,
                                  product_consume_log_id: product_consume_log.id,
                                  month: consume_date.beginning_of_month,
                                  amount: consuming_amount)
    end
  end

  def record_monthly_amount(consume_date)
    product = Product.find(self.product_id)
    use_started_at = self.use_started_at
    MonthlyConsumeAmount.where(product_consume_log_id: self.id).destroy_all
    if consume_date == use_started_at || self.use_ended_at.nil? || consume_date <= use_started_at.end_of_month
      consuming_amount = product.price
      MonthlyConsumeAmount.create(product_id: product.id,
                                  product_consume_log_id: self.id,
                                  month: use_started_at.beginning_of_month,
                                  amount: consuming_amount)
    else
      consume_dates = Enumerator.produce(use_started_at, &:next_month).take_while { |d| d <= consume_date }
      consume_dates.delete_at(-1) if consume_dates.last > self.use_ended_at
      consume_dates.push(self.use_ended_at)
      parameter_to_calculate_monthly_amount = {}
      parameter_to_calculate_monthly_amount[:consume_dates] = consume_dates
      parameter_to_calculate_monthly_amount[:product] = product
      parameter_to_calculate_monthly_amount[:product_consume_log] = self
      calculate_amount_by_month(parameter_to_calculate_monthly_amount)
    end
  end

  def calculate_average_period
    consume_logs = ProductConsumeLog.where('product_id=?', self.product_id).where.not(use_ended_at: nil)
    if consume_logs.empty?
      0
    else
      number_of_consume_logs = consume_logs.count
      total_period = 0
      consume_logs.each do |log|
        period = log.use_ended_at - log.use_started_at + 1 # X日間という数え方をしたいので1を足している
        total_period += period.numerator
      end
      total_period / number_of_consume_logs
    end
  end

  def calculate_average_amount_per_day
    consume_logs = ProductConsumeLog.where('product_id=?', self.product_id).where.not(use_ended_at: nil)
    product = Product.find(self.product_id)
    if consume_logs.empty?
      0
    else
      number_of_consume_logs = consume_logs.count
      total_amount_per_day = 0
      consume_logs.each do |log|
        period = log.use_ended_at - log.use_started_at + 1 # X日間という数え方をしたいので1を足している
        total_amount_per_day += (product.price / period.numerator)
      end
      total_amount_per_day / number_of_consume_logs
    end
  end
end
