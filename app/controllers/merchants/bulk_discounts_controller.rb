class Merchants::BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = Holiday.new
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.bulk_discounts.create!(discount_params)

    if @discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else 
      redirect_to merchant_bulk_discount_path
      flash[:error] = "Error: #{error_message(bulk_discount.errors)}"
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    discount.update(discount_params)

    redirect_to merchant_bulk_discount_path(@merchant, discount)
    flash[:notice] = "You have successfully updated this discount!"
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    discount.destroy 

    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private 
    def discount_params 
      params.require(:bulk_discount).permit(:name, :percent_discount, :threshold)
    end
end