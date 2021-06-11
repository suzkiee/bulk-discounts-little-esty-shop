# spec/features/merchants/bulk_discounts/show_spec

require 'rails_helper'

RSpec.describe 'Bulk Discounts index page' do
  describe 'display' do
    before :each do 
      @merchant = Merchant.create!(name: 'Sally Handmade')
      @discount_1 = create(:mock_bulk_discount, merchant: @merchant)
      @discount_2 = create(:mock_bulk_discount, merchant: @merchant)
      visit merchant_bulk_discount_path(@merchant, @discount_1)
    end

    it 'lists discount and its attributes' do
      first_discount = "#{@discount_1.percent_discount}% off #{@discount_1.threshold} items"
      second_discount = "#{@discount_2.percent_discount}% off #{@discount_2.threshold} items"

      expect(page).to have_content(@discount_1.name)
      expect(page).to have_content(first_discount)
      expect(page).to_not have_content(@discount_2.name)
      expect(page).to_not have_content(second_discount)
    end
  end
end