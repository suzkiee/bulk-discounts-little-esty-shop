# spec/features/merchants/bulk_discounts/index_spec

require 'rails_helper'

RSpec.describe 'Bulk discount index page' do
  before :each do 
    @merchant = Merchant.create!(name: 'Sally Handmade')
    @merchant_2 = Merchant.create!(name: 'Billy Mandmade')
    @discount_1 = create(:mock_bulk_discount, merchant: @merchant)
    @discount_2 = create(:mock_bulk_discount, merchant: @merchant)
    @discount_3 = create(:mock_bulk_discount, merchant: @merchant_2)
    visit merchant_bulk_discounts_path(@merchant)
  end

  describe 'display' do
    it 'lists all the bulk discounts and attributes' do
      first_discount = "#{@discount_1.percent_discount}% off #{@discount_1.threshold} items"
      second_discount = "#{@discount_2.percent_discount}% off #{@discount_2.threshold} items"
      third_discount = "#{@discount_3.percent_discount}% off #{@discount_3.threshold} items"

      expect(page).to have_content(@discount_1.name)
      expect(page).to have_content(first_discount)
      expect(page).to have_content(@discount_2.name)
      expect(page).to have_content(second_discount)
      expect(page).to_not have_content(@discount_3.name)
      expect(page).to_not have_content(third_discount)
    end
    
    it 'links to each individual bulk discount show page' do

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
      expect(page).to have_link(@discount_1.name)

      click_on(@discount_1.name)
      
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_1))
    end

    it 'links to page to create new bulk discount' do
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))

      click_on("Create New Bulk Discount")

      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
    end
  end

  describe 'functionality' do
    it 'deletes discount from index page' do
      expect(page).to have_content("#{@discount_1.name}")
      
      click_on("Delete #{@discount_1.name} Discount")

      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant)) 
      expect(page).to_not have_content("#{@discount_1.name}") 
    end
  end
end