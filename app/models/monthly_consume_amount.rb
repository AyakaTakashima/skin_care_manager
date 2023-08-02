# frozen_string_literal: true

class MonthlyConsumeAmount < ApplicationRecord
  belongs_to :product
  belongs_to :product_consume_log

  validates :month, presence: true

  scope :viewable, lambda { |current_user|
    MonthlyConsumeAmount.includes(product: :user).where(user: { id: current_user })
  }

  def self.average_amount_by_month
    this_month = Time.current.beginning_of_month
    last_year = Time.current.beginning_of_month - 1.year
    total_amount = where('month <= ?', this_month).where('month >= ?', last_year).sum(:amount)
    number_of_recorded_months = count('distinct month')
    if total_amount.zero?
      0
    else
      total_amount / number_of_recorded_months
    end
  end

  def self.get_number_of_consumed_products(date)
    where(month: date).count('distinct product_id')
  end

  def self.calculate_monthly_consume_amounts(date)
    where(month: date).sum(:amount)
  end
end
