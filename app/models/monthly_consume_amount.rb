class MonthlyConsumeAmount < ApplicationRecord
  belongs_to :product
  belongs_to :product_consume_log

  validates :month, presence: true

  def self.calculate_average_amount_by_month(monthly_consume_amounts)
    this_month = Date.today.beginning_of_month
    last_year = Date.today.beginning_of_month - 1.year
    total = monthly_consume_amounts.where('month <= ?', this_month).where('month >= ?', last_year).sum(:amount)
    months = monthly_consume_amounts.count('distinct month')
    total / months
  end

  def self.get_number_of_consumed_products(monthly_consume_amounts, date)
    monthly_consume_amounts.where(month: date).count('distinct product_id')
  end

  def self.calculate_monthly_consume_amounts(monthly_consume_amounts, date)
    monthly_consume_amounts.where(month: date).sum(:amount)
  end
end
