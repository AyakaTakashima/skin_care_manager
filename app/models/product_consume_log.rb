class ProductConsumeLog < ApplicationRecord
  belongs_to :product
  has_many :monthly_consume_amounts, dependent: :destroy

  validates :use_started_at, presence: true

  def calculate_amount(info_to_calculate)
    product = info_to_calculate[:product]
    product_consume_log = info_to_calculate[:product_consume_log]

    last_index = info_to_calculate[:months].count - 1
    info_to_calculate[:months].each_with_index do |month, index|
      if index == 0
        consuming_amount = ((month.end_of_month - month).numerator + 1) * product.average_amount_per_day
      elsif index == last_index
        total_amount_until_last_month = MonthlyConsumeAmount.where(product_consume_log_id: product_consume_log.id).sum(:amount)
        consuming_amount = product.price - total_amount_until_last_month
      else
        consuming_amount = ((month.end_of_month - month.beginning_of_month).numerator + 1) * product.average_amount_per_day
      end

      MonthlyConsumeAmount.create(product_id: product.id,
                                  product_consume_log_id: product_consume_log.id,
                                  month: month.beginning_of_month,
                                  amount: consuming_amount)
    end
  end

  def record_monthly_amount(date, product_consume_log)
    product = Product.find(product_consume_log.product_id)
    use_started_at = product_consume_log.use_started_at
    MonthlyConsumeAmount.where(product_consume_log_id: product_consume_log.id).destroy_all

    if date > use_started_at.end_of_month
      months = Enumerator.produce(use_started_at, &:next_month).take_while{|d| d <= date}
      info_to_calculate = {}
      info_to_calculate[:months] = months
      info_to_calculate[:product] = product
      info_to_calculate[:product_consume_log] = product_consume_log
      calculate_amount(info_to_calculate)
    else
      consuming_amount = product.price
      MonthlyConsumeAmount.create(product_id: product.id,
                                  product_consume_log_id: product_consume_log.id,
                                  month: use_started_at.beginning_of_month,
                                  amount: consuming_amount)
    end
  end
end
