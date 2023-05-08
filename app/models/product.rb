# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :user
  has_many :product_consume_logs, dependent: :destroy
  has_many :monthly_consume_amounts, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true

  def in_use?(product_id)
    Product.joins(:product_consume_logs)
           .where('product_id=?', product_id)
           .where(product_consume_logs: { use_ended_at: nil })
           .exists?
  end

  def calculate_scheduled_consume_date(id)
    product = Product.find(id)
    return if product.product_consume_logs.empty?

    last_use_started_day = product.product_consume_logs.last.use_started_at
    last_use_ended_day = product.product_consume_logs.last.use_ended_at
    average_period = product.average_period
    return unless last_use_ended_day.nil? && !average_period.zero?

    last_use_started_day + average_period.day
  end

  def format_scheduled_consume_date(id)
    scheduled_consume_date = calculate_scheduled_consume_date(id)
    if scheduled_consume_date.nil?
      '-'
    else
      wday = %w[日 月 火 水 木 金 土]
      scheduled_consume_date.strftime("%m/%d(#{wday[scheduled_consume_date.wday]})")
    end
  end

  def count_until_scheduled_consume_date(id)
    scheduled_consume_date = calculate_scheduled_consume_date(id)
    if !scheduled_consume_date.nil?
      today = Time.zone.today
      result = scheduled_consume_date - today
      result.numerator
    else
      '-'
    end
  end

  def get_number_of_consume_logs(product, date)
    product.monthly_consume_amounts.where(month: date).count('distinct product_id')
  end

  def calculate_monthly_consume_amounts(product, date)
    MonthlyConsumeAmount.where(product_id: product.id).where(month: date).sum(:amount)
  end
end
