class MonthlyConsumeAmountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: %i[ new use_end edit update ]

  def index
    @monthly_consume_amounts = MonthlyConsumeAmount.includes(product: :user).where(user:{id:current_user.id})
    @date = Date.today.beginning_of_month + 1.month #viewでループ処理をするために1ヶ月足しておく
  end

  def show
    year = params[:year].to_i
    month = params[:month].to_i
    if !(Date.valid_date?(year,month,1)) || (Date.new(year, month) > Date.today)
      raise ActiveRecord::RecordNotFound
    end
    @date = Date.new(year,month)
    @monthly_consume_amounts = MonthlyConsumeAmount.includes(product: :user)
                                                   .where(user:{id:current_user.id})
                                                   .where('month=?',@date)
    @products = Product.includes(:monthly_consume_amounts, :user)
                       .where(user:{id:current_user.id})
                       .where(monthly_consume_amounts:{month: @date})
  end
end