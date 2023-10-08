# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_product, only: %i[show edit update destroy]

  def index
    if current_user
      @products = current_user.products.with_attached_avatar.includes(:product_consume_logs).order(created_at: :desc)
      @amount = @products.includes(:monthly_consume_amounts).where('monthly_consume_amounts.month=?', Time.current.beginning_of_month).sum(:amount)
      render aciton: :index
    else
      render template: 'top/index', layout: 'top'
    end
  end

  def show
    @product_consume_logs = @product.product_consume_logs.order(id: :asc).reverse
    @number_of_logs = @product_consume_logs.count + 1
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id

    if @product.save
      redirect_to root_url, notice: "#{t('activerecord.models.product')}#{t('notice.create')}"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to product_url(@product), notice: "#{t('activerecord.models.product')}#{t('notice.update')}"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to root_url, notice: "#{t('activerecord.models.product')}#{t('notice.destroy')}"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :user_id,
      :name,
      :price,
      :average_period,
      :avatar
    )
  end
end
