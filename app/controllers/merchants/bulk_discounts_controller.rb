class Merchants::BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new 
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.bulk_discounts.create!(discount_params)

    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def update
  end

  def destroy
  end

  private 
    def discount_params 
      params.require(:bulk_discount).permit(:name, :percent_discount, :threshold)
    end
end